{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenSurefireGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/plugins/maven-compiler-plugin/;
      description = "The Surefire Plugin is used during the test phase of the build lifecycle to execute the unit tests of an application";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenSurefire23 = mavenSurefireGen {
    name = "maven-surefire-plugin-2.3";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.3/maven-surefire-plugin/";
      rev = 1724719;
      sha256 = "0ivnnv9w58fgcxngbwd3npsakc9cn8qlzcd13lyhzyc6nkdw9f3b";
    };
    mavenDeps = [ bootstrapMavenClean25Jar bootstrapMavenCompiler31Jar bootstrapMavenPlugin32Jar bootstrapMavenResources26Jar bootstrapMavenSurefire23Jar apacheParent3 mavenJar24 mavenParent5 surefireParent23 ];
    m2Path = "/org/apache/maven/plugins/maven-surefire-plugin/2.3";
  };

  mavenSurefire231 = mavenSurefireGen {
    name = "maven-surefire-plugin-2.3.1";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.3.1/maven-surefire-plugin/";
      rev = 1724719;
      sha256 = "1h21n515abqhznn91ngfx3ygpglvqmx1ysjkw00drxy2ls1mln10";
    };
    mavenDeps = [ bootstrapMavenClean25Jar bootstrapMavenCompiler31Jar bootstrapMavenPlugin32Jar bootstrapMavenResources26Jar apacheParent3 mavenParent5 mavenSurefire23 surefireParent231 ];
    m2Path = "/org/apache/maven/plugins/maven-surefire-plugin/2.3.1";
  };

  mavenSurefire243 = mavenSurefireGen {
    name = "maven-surefire-plugin-2.4.3";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.4.3/maven-surefire-plugin/";
      rev = 1724719;
      sha256 = "0f07rwfwb67dwywvfsd77qgyn3pafl1hm010j9wp3sy0ckyl13pm";
    };
    mavenDeps = [ bootstrapMavenClean25Jar bootstrapMavenCompiler31Jar bootstrapMavenPlugin32Jar bootstrapMavenRemoteResources10alpha6Jar bootstrapMavenResources26Jar apacheParent4 mavenParent7 mavenSurefire231 surefireParent243 ];
    m2Path = "/org/apache/maven/plugins/maven-surefire-plugin/2.4.3";
  };

  mavenSurefire272 = mavenSurefireGen {
    name = "maven-surefire-plugin-2.7.2";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.7.2/maven-surefire-plugin/";
      rev = 1724719;
      sha256 = "1wiqaclskaq6d9gsm1mpq5g83nhi1pyb11sbc9dccfqamfahpb7i";
    };
    mavenDeps = [ bootstrapMavenPlugin26Jar bootstrapMavenRemoteResources11Jar apacheParent8 mavenParent18 mavenSite22 surefireParent272 ];
    m2Path = "/org/apache/maven/plugins/maven-surefire-plugin/2.7.2";
  };

  mavenSurefire28 = mavenSurefireGen {
    name = "maven-surefire-plugin-2.8";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.8/maven-surefire-plugin/";
      rev = 1724719;
      sha256 = "068zid0binxg517bhkmbv3fr3h62sgyw543x0lzsgigj0yd4hz9w";
    };
    mavenDeps = [ bootstrapMavenClean241Jar bootstrapMavenCompiler232Jar bootstrapMavenPlugin27Jar bootstrapMavenRemoteResources11Jar bootstrapMavenResources243Jar apacheParent9 mavenParent19 mavenSurefire272 surefireParent28 ];
    m2Path = "/org/apache/maven/plugins/maven-surefire-plugin/2.8";
  };

  mavenSurefire29 = mavenSurefireGen {
    name = "maven-surefire-plugin-2.9";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.9/maven-surefire-plugin/";
      rev = 1724719;
      sha256 = "10c7md5lbl78g6yixii6fia5s09nx3agk5xiz0ds7994axv6cgly";
    };
    mavenDeps = [ bootstrapMavenClean241Jar bootstrapMavenCompiler232Jar bootstrapMavenPlugin28Jar bootstrapMavenRemoteResources11Jar bootstrapMavenResources243Jar apacheParent9 mavenParent19 mavenSurefire28 surefireParent29 ];
    m2Path = "/org/apache/maven/plugins/maven-surefire-plugin/2.9";
  };
}
