{stdenv, fetchurl, unzip, makeWrapper}:

let
  # Gradle is a build system that bootstraps itself. This is what it actually
  # downloads in the bootstrap phase.
  gradleAllZip = fetchurl {
    url = http://services.gradle.org/distributions/gradle-4.1-all.zip;
    sha256 = "1rcrh263vq7a0is800y5z36jj97p67c6zpqzzfcbr7r0qaxb61sw";
  };

  # A Titanium-Android build requires proguard plugins. We create a fake
  # repository so that Gradle does not attempt to download them in the builder.
  # Since there are only 3 plugins required, this is still (sort of) manageable
  # without a generator.
  proguardVersion = "5.3.3";

  proguardGradlePOM = fetchurl {
    url = "https://repo1.maven.org/maven2/net/sf/proguard/proguard-gradle/${proguardVersion}/proguard-gradle-${proguardVersion}.pom";
    sha256 = "03v9zm3ykfkyb5cs5ald07ph103fh68d5c33rv070r29p71dwszj";
  };
  proguardGradleJAR = fetchurl {
    url = "https://repo1.maven.org/maven2/net/sf/proguard/proguard-gradle/${proguardVersion}/proguard-gradle-${proguardVersion}.jar";
    sha256 = "0shhpsjfc5gam15jnv1hk718v5c7vi7dwdc3gvmnid6dc85kljzk";
  };
  proguardParentPOM = fetchurl {
    url = "https://repo1.maven.org/maven2/net/sf/proguard/proguard-parent/${proguardVersion}/proguard-parent-${proguardVersion}.pom";
    sha256 = "0mv0zbwyw8xa4mkc5kw69y5xqashkz9gp123akfvh9f6152l3202";
  };
  proguardBasePOM = fetchurl {
    url = "https://repo1.maven.org/maven2/net/sf/proguard/proguard-base/${proguardVersion}/proguard-base-${proguardVersion}.pom";
    sha256 = "1jnr6zsxfimb8wglqlwa6rrdc3g3nqf1dyw0k2dq9cj0q4pgn7p5";
  };
  proguardBaseJAR = fetchurl {
    url = "https://repo1.maven.org/maven2/net/sf/proguard/proguard-base/${proguardVersion}/proguard-base-${proguardVersion}.jar";
    sha256 = "11nwdb9y84cghcx319nsjjf9m035s4s1184zrhzpvaxq2wvqhbhx";
  };

  # Put the downloaded plugins in a fake Maven repository
  fakeMavenRepo = stdenv.mkDerivation {
    name = "fake-maven-repo";
    buildCommand = ''
      mkdir -p $out
      cd $out
      mkdir -p net/sf/proguard/proguard-gradle/${proguardVersion}
      cp ${proguardGradlePOM} net/sf/proguard/proguard-gradle/${proguardVersion}/proguard-gradle-${proguardVersion}.pom
      cp ${proguardGradleJAR} net/sf/proguard/proguard-gradle/${proguardVersion}/proguard-gradle-${proguardVersion}.jar
      mkdir -p net/sf/proguard/proguard-parent/${proguardVersion}
      cp ${proguardParentPOM} net/sf/proguard/proguard-parent/${proguardVersion}/proguard-parent-${proguardVersion}.pom
      mkdir -p net/sf/proguard/proguard-base/${proguardVersion}
      cp ${proguardBasePOM} net/sf/proguard/proguard-base/${proguardVersion}/proguard-base-${proguardVersion}.pom
      cp ${proguardBaseJAR} net/sf/proguard/proguard-base/${proguardVersion}/proguard-base-${proguardVersion}.jar
    '';
  };
in
stdenv.mkDerivation {
  name = "mobilesdk-8.3.2.GA";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") then fetchurl {
    url = https://builds.appcelerator.com/mobile/8_3_X/mobilesdk-8.3.2.v20200117111803-linux.zip;
    sha256 = "04pfw21jrx9w259lphynwykqjk4c9hm0zix4d40s7mf8mmh3xdx9";
  }
  else if stdenv.system == "x86_64-darwin" then fetchurl {
    url = https://builds.appcelerator.com/mobile/8_3_X/mobilesdk-8.3.2.v20200117111803-osx.zip;
    sha256 = "1zflq5hc96lrriw71ya623kkskkisi9yayg8qs03zimi0gksizxw";
  }
  else throw "Platform: ${stdenv.system} not supported!";

  buildInputs = [ unzip makeWrapper ];

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src

    # Rename ugly version number
    cd mobilesdk/*
    mv * 8.3.2.GA
    cd *

    # Patch bundled gradle build infrastructure to make shebangs work
    patchShebangs android/templates/gradle

    # Substitute the gradle-all zip URL by a local file to prevent downloads from happening while building an Android app
    sed -i -e "s|distributionUrl=|#distributionUrl=|" android/templates/gradle/gradle/wrapper/gradle-wrapper.properties
    cp ${gradleAllZip} android/templates/gradle/gradle/wrapper/gradle-4.1-all.zip
    echo "distributionUrl=gradle-4.1-all.zip" >> android/templates/gradle/gradle/wrapper/gradle-wrapper.properties

    # Patch maven central repository with our own local directory. This prevents the builder from downloading Maven artifacts
    sed -i -e 's|mavenCentral()|maven { url "${fakeMavenRepo}" }|' android/templates/build/proguard.gradle

    ${stdenv.lib.optionalString (stdenv.system == "x86_64-darwin") ''
      # Patch the strip frameworks script in the iPhone build template to not let
      # it skip the strip phase. This is caused by an assumption on the file
      # permissions in which Nix deviates from the standard.
      sed -i -e "s|-perm +111|-perm /111|" iphone/templates/build/strip-frameworks.sh
    ''}
  '';
}
