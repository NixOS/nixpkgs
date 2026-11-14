{
  lib,
  python3Packages,
  fetchFromGitHub,
  pkg-config,
  pcre,
  hyperscan,
  testers,
  runCommand,
}:

let
  self = python3Packages.buildPythonApplication rec {
    pname = "wordfence-cli";
    version = "5.0.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "wordfence";
      repo = "wordfence-cli";
      rev = "v${version}";
      sha256 = "13hb1xikm8824hhfmv9ggmmkp637yfkf7z58338p66z9l7hsjq1i";
    };

    nativeBuildInputs = with python3Packages; [
      pkg-config
      setuptools
      pip
      pcre
      hyperscan
    ];

    propagatedBuildInputs = with python3Packages; [
      packaging
      requests
      pymysql
    ];

    patches = [
      ./library.patch
    ];

    postPatch = ''
      substituteInPlace wordfence/util/library.py \
        --replace-fail '@PCRE_OUT@' "${pcre.out}" \
        --replace-fail '@HS_OUT@'  "${hyperscan.out}"
    '';

    doCheck = false;

    passthru.tests = {
      version = testers.testVersion {
        package = self;
        command = "wordfence --version";
        version = "Wordfence CLI ${version}";
      };

      pcreSupported =
        runCommand "wordfence-cli-pcre-supported"
          {
            nativeBuildInputs = [ self ];
          }
          ''
            wordfence --version | grep -F "PCRE Supported: Yes"
            touch $out
          '';

      vectorscanSupported =
        runCommand "wordfence-cli-vectorscan-supported"
          {
            nativeBuildInputs = [ self ];
          }
          ''
            wordfence --version | grep -F "Vectorscan Supported: Yes"
            touch $out
          '';
    };

    meta = {
      description = "Wordfence malware and vulnerability scanner command line utility";
      homepage = "https://github.com/wordfence/wordfence-cli";
      changelog = "https://github.com/wordfence/wordfence-cli/releases";
      license = lib.licenses.gpl3;
      maintainers = [ lib.maintainers.am-on ];
      platforms = [
        "x86_64-linux"
      ];
    };
  };
in
self
