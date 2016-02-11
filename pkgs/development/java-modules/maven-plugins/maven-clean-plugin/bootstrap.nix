{ fetchmaven, fetchurl }:

rec {
  mavenClean23Jar = fetchmaven {
    version = "2.3";
    name = "bootstrap-maven-clean-plugin-jar-2.3";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-clean-plugin/2.3/maven-clean-plugin-2.3.jar";
      sha256 = "1sq599x3ki8sakfx5sby6yaxjvv4aawbksp9lnj3chyv36cha000";
    };
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.3";
    m2File = "maven-clean-plugin-2.3.jar";
  };

  mavenClean24Jar = fetchmaven {
    version = "2.4";
    name = "bootstrap-maven-clean-plugin-jar-2.4";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-clean-plugin/2.4/maven-clean-plugin-2.4.jar";
      sha256 = "1d7dr9prckn0df3pckpra227ygbnq76qfrf64zbq8s2haj8dywfr";
    };
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.4";
    m2File = "maven-clean-plugin-2.4.jar";
  };

  mavenClean241Jar = fetchmaven {
    version = "2.4.1";
    name = "bootstrap-maven-clean-plugin-jar-2.4.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-clean-plugin/2.4.1/maven-clean-plugin-2.4.1.jar";
      sha256 = "1jl96cwydk8dcfvyabbywygg5lqza3vgnndqh60drd4kngvax615";
    };
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.4.1";
    m2File = "maven-clean-plugin-2.4.1.jar";
  };

  mavenClean241Pom = fetchmaven {
    version = "2.4.1";
    name = "bootstrap-maven-clean-plugin-pom-2.4.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-clean-plugin/2.4.1/maven-clean-plugin-2.4.1.pom";
      sha256 = "0swwg1yd7zxv904l5b7v2qbyd862q4amlxmxxk59z3caw3cxjhd0";
    };
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.4.1";
    m2File = "maven-clean-plugin-2.4.1.pom";
  };

  mavenClean25Jar = fetchmaven {
    version = "2.5";
    name = "bootstrap-maven-clean-plugin-jar-2.5";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-clean-plugin/2.5/maven-clean-plugin-2.5.jar";
      sha256 = "0wxg8yyz5jsy35pvjy5cwsbv4306q3gay1gyvwq604966qs34af2";
    };
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.5";
    m2File = "maven-clean-plugin-2.5.jar";
  };
}
