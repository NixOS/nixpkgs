{ fetchmaven, fetchurl }:

rec {
  mavenRemoteResourcesAlpha6Jar = fetchmaven {
    version = "1.0-alpha-6";
    name = "maven-remote-resources-plugin-jar";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.0-alpha-6/maven-remote-resources-plugin-1.0-alpha-6.jar";
      sha256 = "1193xrrxcy9xgva89vvarw65q3gskzpgj0ysw9qqvb65pa6fk2wr";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.0-alpha-6";
    m2File = "maven-remote-resources-plugin-1.0-alpha-6.jar";
  };

  mavenRemoteResources121Jar = fetchmaven {
    version = "1.2.1";
    name = "maven-remote-resources-plugin-jar";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.2.1/maven-remote-resources-plugin-1.2.1.jar";
      sha256 = "1kw6s4znp52q2y1l9k6wn6vxmcs9xas4mnmd748lhily9hanmi95";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.2.1";
    m2File = "maven-remote-resources-plugin-1.2.1.jar";
  };

  mavenRemoteResources121Pom = fetchmaven {
    version = "1.2.1";
    name = "maven-remote-resources-plugin-pom";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.2.1/maven-remote-resources-plugin-1.2.1.pom";
      sha256 = "1sr907vvgswljazviabs5vwyw6kb3kywxzrcqvqwlr3gj8x6bj9v";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.2.1";
    m2File = "maven-remote-resources-plugin-1.2.1.pom";
  };

  mavenRemoteResources11Jar = fetchmaven {
    version = "1.1";
    name = "maven-remote-resources-plugin-jar";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.1/maven-remote-resources-plugin-1.1.jar";
      sha256 = "0vhwbwggj28755xk924kj1jnrqnqqi73rb3i1pd5q5998xcb3a4x";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.1";
    m2File = "maven-remote-resources-plugin-1.1.jar";
  };

  mavenRemoteResources11Pom = fetchmaven {
    version = "1.1";
    name = "maven-remote-resources-plugin-pom";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.1/maven-remote-resources-plugin-1.1.pom";
      sha256 = "0gvz7z5hzbnn1jpgw5g3620rhp8zqckqzzd9vvwq7l74drq6dgd8";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.1";
    m2File = "maven-remote-resources-plugin-1.1.pom";
  };

}
