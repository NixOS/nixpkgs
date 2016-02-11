{ fetchmaven, fetchurl }:

rec {
  mavenRemoteResourcesAlpha6Jar = fetchmaven {
    version = "1.0-alpha-6";
    name = "bootstrap-maven-remote-resources-plugin-jar-1.0-alpha-6";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.0-alpha-6/maven-remote-resources-plugin-1.0-alpha-6.jar";
      sha256 = "1193xrrxcy9xgva89vvarw65q3gskzpgj0ysw9qqvb65pa6fk2wr";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.0-alpha-6";
    m2File = "maven-remote-resources-plugin-1.0-alpha-6.jar";
  };

  mavenRemoteResources10Jar = fetchmaven {
    version = "1.0";
    name = "bootstrap-maven-remote-resources-plugin-jar-1.0";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.0/maven-remote-resources-plugin-1.0.jar";
      sha256 = "1s2h4z4xss7zmjz7jg9ia960kwgb1s7vcyc0wqs0fr6a8xkfqzhj";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.0";
    m2File = "maven-remote-resources-plugin-1.0.jar";
  };

  mavenRemoteResources11Jar = fetchmaven {
    version = "1.1";
    name = "bootstrap-maven-remote-resources-plugin-jar-1.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.1/maven-remote-resources-plugin-1.1.jar";
      sha256 = "0vhwbwggj28755xk924kj1jnrqnqqi73rb3i1pd5q5998xcb3a4x";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.1";
    m2File = "maven-remote-resources-plugin-1.1.jar";
  };

  mavenRemoteResources11Pom = fetchmaven {
    version = "1.1";
    name = "bootstrap-maven-remote-resources-plugin-pom-1.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.1/maven-remote-resources-plugin-1.1.pom";
      sha256 = "0gvz7z5hzbnn1jpgw5g3620rhp8zqckqzzd9vvwq7l74drq6dgd8";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.1";
    m2File = "maven-remote-resources-plugin-1.1.pom";
  };

  mavenRemoteResources121Jar = fetchmaven {
    version = "1.2.1";
    name = "bootstrap-maven-remote-resources-plugin-jar-1.2.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.2.1/maven-remote-resources-plugin-1.2.1.jar";
      sha256 = "1kw6s4znp52q2y1l9k6wn6vxmcs9xas4mnmd748lhily9hanmi95";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.2.1";
    m2File = "maven-remote-resources-plugin-1.2.1.jar";
  };

  mavenRemoteResources121Pom = fetchmaven {
    version = "1.2.1";
    name = "bootstrap-maven-remote-resources-plugin-pom-1.2.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.2.1/maven-remote-resources-plugin-1.2.1.pom";
      sha256 = "1sr907vvgswljazviabs5vwyw6kb3kywxzrcqvqwlr3gj8x6bj9v";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.2.1";
    m2File = "maven-remote-resources-plugin-1.2.1.pom";
  };

  mavenRemoteResources13Jar = fetchmaven {
    version = "1.3";
    name = "bootstrap-maven-remote-resources-plugin-jar-1.3";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-remote-resources-plugin/1.3/maven-remote-resources-plugin-1.3.jar";
      sha256 = "1c6j009492737j90ifmf1zk5rnjlgv5fgndvwcbn36ir4qn0808r";
    };
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.3";
    m2File = "maven-remote-resources-plugin-1.3.jar";
  };
}
