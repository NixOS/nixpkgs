import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URI;
import java.net.http.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

public class JavaUpdater {

  record GitHubResult(Optional<String> latestVersion, Optional<String> next) {
  }

  record JsonInfo(String repo, String version, String hash) {
    public JsonInfo(JSONObject json) {
      this(json.getString("repo"), json.getString("version"), json.getString("hash"));
    }

    public String toJsonString(String featureVersion) {
      return """
        \s "%s": {
        \s   "version": "%s",
        \s   "repo":    "%s",
        \s   "hash":    "%s"
        \s }\
        """.formatted(featureVersion, version, repo, hash);
    }
  }

  // Parses the GitHub Link header
  public static Optional<String> getNextLink(HttpHeaders headers) {
    var linkHeader = headers.map().get("Link");
    if (linkHeader == null || linkHeader.isEmpty()) return null;

    var links = linkHeader.getFirst();
    var linksRegex = Pattern.compile("<(.+)>;\\s*rel=\"next\"");
    return Pattern.compile(",")
      .splitAsStream(links)
      .map(x -> linksRegex.matcher(x).results()
        .map(g -> g.group(1))
        .findFirst()
      )
      .filter(Optional::isPresent)
      .map(Optional::orElseThrow)
      .findFirst();
  }

  // HTTP request helper, sets GITHUB_TOKEN if present
  private static HttpRequest NewGithubRequest(String url) {
    var token = System.getenv().get("GITHUB_TOKEN");
    var builder = HttpRequest.newBuilder()
      .uri(URI.create(url));
    if (token != null)
      builder.setHeader("Authorization", "Bearer " + token);
    return builder.build();
  }

  private static GitHubResult getLatestTag(String url) {
    var request = NewGithubRequest(url);

    var response =
      HttpClient.newHttpClient().sendAsync(request, HttpResponse.BodyHandlers.ofString())
        .join();

    var json = new JSONArray(response.body());

    Optional<String> version = StreamSupport.stream(json.spliterator(), false)
      .map(JSONObject.class::cast)
      .map(x -> x.getString("name").replaceFirst("jdk-", ""))
      .filter(x -> x.contains("-ga"))
      .max(Comparator.comparing(Runtime.Version::parse));

    return new GitHubResult(version, getNextLink(response.headers()));
  }

  public String findNewerVersion() {
    var url = Optional.of("https://api.github.com/repos/openjdk/" + getRepo() + "/tags?per_page=100");
    String version = getCurrentVersion();
    do {
      GitHubResult response = getLatestTag(url.orElseThrow());
      if (response.latestVersion.isPresent() && response.latestVersion.orElseThrow().equals(version)) {
        return null;
      }

      String latestVersion = Stream.of(version, response.latestVersion.orElse(version))
        .max(Comparator.comparing(Runtime.Version::parse)).orElseThrow();

      if (latestVersion != version)
        return latestVersion;

      url = response.next;
    } while (url.isPresent());
    return null;
  }


  private static String prettyPrint(JSONObject json) {

    Iterable<String> iterable = () -> json.keys();

    return StreamSupport
      .stream(iterable.spliterator(), false)
      .sorted(Comparator.reverseOrder())
      .map(majorVersion -> (new JsonInfo(json.getJSONObject(majorVersion))).toJsonString(majorVersion))
      .collect(
        Collectors.joining(",\n", "{\n", "\n}")
      );
  }

  public void updateJsonInfo(String newVersion) {
    try {
      JSONObject json = getJsonInfo();
      var info = json.getJSONObject(featureNumber);
      info.put("version", newVersion);
      info.put("hash", nixHash(newVersion));

      try (PrintWriter out = new PrintWriter(infoJsonPath)) {
        out.println(prettyPrint(json));
      }

    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }

  private String nixHash(String version) {
    try {
      var process = new ProcessBuilder("nix", "flake", "prefetch",
        "--extra-experimental-features", "'nix-command flakes'",
        "--json", "github:openjdk/" + getRepo() + "/jdk-" + version).start();

      var json = new JSONObject(new String(process.getInputStream().readAllBytes()));
      process.waitFor();
      return json.getString("hash");
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }

  private final String featureNumber;
  private final String infoJsonPath;
  private final JSONObject jsonInfo;

  public String getCurrentVersion() {
    return this.jsonInfo.getJSONObject(this.featureNumber).getString("version");
  }

  public String getRepo() {
    return this.jsonInfo.getJSONObject(this.featureNumber).getString("repo");
  }

  public JSONObject getJsonInfo() {
    try {
      String infoStr = Files.readString(Path.of(this.infoJsonPath));
      return new JSONObject(infoStr);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  public JavaUpdater(String featureNumber, String infoJsonPath) {
    this.featureNumber = featureNumber;
    this.infoJsonPath = infoJsonPath;
    this.jsonInfo = getJsonInfo();
  }

  public static void main(String[] args) {
    var updater = new JavaUpdater(args[0], args[1]);
    String newerVersion = updater.findNewerVersion();
    if (newerVersion != null) {
      updater.updateJsonInfo(newerVersion);
    }
  }
}
