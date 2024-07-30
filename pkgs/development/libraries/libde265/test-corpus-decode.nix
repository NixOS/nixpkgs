{ stdenv
, fetchFromGitHub
, libde265
}:

stdenv.mkDerivation {
  pname = "libde265-test-corpus-decode";
  version = "unstable-2020-02-19";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libde265-data";
    rev = "bdfdfdbe682f514c5185c270c74eac42731a7fa8";
    sha256 = "sha256-fOgu7vMoyH30Zzbkfm4a6JVDZtYLO/0R2syC2Wux+Z8=";
  };

  dontConfigure = true;
  dontBuild = true;

  doCheck = true;
  nativeCheckInputs = [ libde265 ];
  # based on invocations in https://github.com/strukturag/libde265/blob/0b1752abff97cb542941d317a0d18aa50cb199b1/scripts/ci-run.sh
  checkPhase = ''
    echo "Single-threaded:"
    find . -name '*.bin' | while read f; do
      echo "Decoding $f"
      dec265 -q -c $f
      dec265 -0 -q -c $f
      dec265 -q --disable-deblocking --disable-sao $f
    done
    echo "Multi-threaded:"
    find RandomAccess/ -name '*.bin' | while read f; do
      echo "Decoding $f"
      dec265 -t 4 -q -c $f
      dec265 -t 4 -0 -q -c $f
      dec265 -t 4 -q --disable-deblocking --disable-sao $f
    done
  '';
  # a larger corpus of files can be found
  # as an ubuntu package libde265-teststreams @
  # https://launchpad.net/~strukturag/+archive/ubuntu/libde265/+packages
  # but it is *much* larger

  installPhase = ''
    touch $out
  '';
}
