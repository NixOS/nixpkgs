{ lib, stdenv, buildPythonPackage, fetchFromGitHub, pytest,
  asn1crypto, cffi, pkg-config, autoconf, automake, libtool, libffi,
  requests }:

buildPythonPackage rec {
  pname = "coincurve";
  version = "14.0.0";

  src = fetchFromGitHub {
    owner = "ofek";
    repo = "coincurve";
    rev = "v${version}";
    sha256 = "0z765x9vpb82nx9d0kvqknyl5ad4fldha3nqsx1cydghskdd100r";
  };

  postPatch = ''
      rm coincurve/_windows_libsecp256k1.py
  '';

  checkInputs = [ pytest ];
  nativeBuildInputs = [ autoconf automake libtool pkg-config ];
  propagatedBuildInputs = [ asn1crypto cffi libffi requests ];

  meta = with lib; {
    description = "Cross-platform Python CFFI bindings for libsecp256k1";
    homepage = "https://github.com/ofek/coincurve";
    license = licenses.asl20;
    maintainers = with maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };

}
