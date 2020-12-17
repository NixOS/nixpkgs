{ stdenv, lib, fetchurl, makeWrapper, jre, gnugrep, coreutils, nixosTests
, writeScript, common-updater-scripts, git, gnused, nix, nixfmt, majorVersion }:

with lib;

let
  repo = "git@github.com:scala/scala.git";

  versionMap = {
    "2.10" = {
      version = "2.10.7";
      sha256 = "koMRmRb2u3cU4HaihAzPItWIGbNVIo7RWRrm92kp8RE=";
      tests = [ nixosTests.scala.scala_2_10 ];
      pname = "scala_2_10";
    };

    "2.11" = {
      version = "2.11.12";
      sha256 = "sR19M2mcpPYLw7K2hY/ZU+PeK4UiyUP0zaS2dDFhlqg=";
      tests = [ nixosTests.scala.scala_2_11 ];
      pname = "scala_2_11";
    };

    "2.12" = {
      version = "2.12.12";
      sha256 = "NSDNHzye//YrrudfMuUtHl3BIL4szzQGSeRw5I9Sfis=";
      tests = [ nixosTests.scala.scala_2_12 ];
      pname = "scala_2_12";
    };

    "2.13" = {
      version = "2.13.4";
      sha256 = "1alcnzmxga00nsvgy8yky91zw5b4q0xg2697vrrdgjlglpxiqwdw";
      tests = [ nixosTests.scala.scala_2_13 ];
      pname = "scala_2_13";
    };
  };

in with versionMap.${majorVersion};

stdenv.mkDerivation rec {
  inherit version;

  name = "scala-${version}";

  src = fetchurl {
    inherit sha256;
    url = "https://www.scala-lang.org/files/archive/scala-${version}.tgz";
  };

  propagatedBuildInputs = [ jre ];

  buildInputs = [ makeWrapper ];

  installPhase = ''
      mkdir -p $out
      rm bin/*.bat
      mv * $out
      # put docs in correct subdirectory
      mkdir -p $out/share/doc
      mv $out/doc $out/share/doc/${name}
      mv $out/man $out/share/man
    for p in $(ls $out/bin/) ; do
        wrapProgram $out/bin/$p \
          --prefix PATH ":" ${coreutils}/bin \
          --prefix PATH ":" ${gnugrep}/bin \
          --prefix PATH ":" ${jre}/bin \
          --set JAVA_HOME ${jre}
      done
  '';

  passthru = {
    inherit tests;
    updateScript = writeScript "update.sh" ''
      #!${stdenv.shell}
      set -o errexit
      PATH=${
        stdenv.lib.makeBinPath [
          common-updater-scripts
          coreutils
          git
          gnused
          nix
          nixfmt
        ]
      }
      versionSelect='v${versions.major version}.${versions.minor version}.*'
      oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion ${pname}" | tr -d '"')"
      latestTag="$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags ${repo} "$versionSelect" | tail --lines=1 | cut --delimiter='/' --fields=3 | sed 's|^v||g')"
      if [ "$oldVersion" != "$latestTag" ]; then
        nixpkgs="$(git rev-parse --show-toplevel)"
        default_nix="$nixpkgs/pkgs/development/compilers/scala/2.x.nix"
        update-source-version ${pname} "$latestTag" --version-key=version --print-changes
        nixfmt "$default_nix"
      else
        echo "${pname} is already up-to-date"
      fi
    '';
  };

  meta = {
    description = "A general purpose programming language";
    longDescription = ''
      Scala is a general purpose programming language designed to express
      common programming patterns in a concise, elegant, and type-safe way.
      It smoothly integrates features of object-oriented and functional
      languages, enabling Java and other programmers to be more productive.
      Code sizes are typically reduced by a factor of two to three when
      compared to an equivalent Java application.
    '';
    homepage = "https://www.scala-lang.org/";
    license = licenses.bsd3;
    platforms = platforms.all;
    branch = versions.majorMinor version;
    maintainers = [ maintainers.nequissimus ];
  };
}
