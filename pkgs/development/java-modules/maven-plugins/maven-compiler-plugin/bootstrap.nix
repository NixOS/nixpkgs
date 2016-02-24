{ fetchmaven, fetchurl }:

rec {
  mavenCompiler202Jar = fetchmaven {
    version = "2.0.2";
    name = "bootstrap-maven-compiler-plugin-jar-2.0.2";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-compiler-plugin/2.0.2/maven-compiler-plugin-2.0.2.jar";
      sha256 = "0vlv46098lrjgsxm8acmydmpx60xh95bkn5jyhjvnli1k7s8drkk";
    };
    m2Path = "/org/apache/maven/plugins/maven-compiler-plugin/2.0.2";
    m2File = "maven-compiler-plugin-2.0.2.jar";
  };

  mavenCompiler232Jar = fetchmaven {
    version = "2.3.2";
    name = "bootstrap-maven-compiler-plugin-jar-2.3.2";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-compiler-plugin/2.3.2/maven-compiler-plugin-2.3.2.jar";
      sha256 = "1c7qin86xv4wnjmk0i7chh7878ijc0bnnwni1vbvmzfa0b7vic7x";
    };
    m2Path = "/org/apache/maven/plugins/maven-compiler-plugin/2.3.2";
    m2File = "maven-compiler-plugin-2.3.2.jar";
  };

  mavenCompiler31Jar = fetchmaven {
    version = "3.1";
    name = "bootstrap-maven-compiler-plugin-jar-3.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-compiler-plugin/3.1/maven-compiler-plugin-3.1.jar";
      sha256 = "1ih2qg9xa5zjwrmwkyqlx2vi2mncqihmlhaj3kih9yjbibc6qa32";
    };
    m2Path = "/org/apache/maven/plugins/maven-compiler-plugin/3.1";
    m2File = "maven-compiler-plugin-3.1.jar";
  };
}
