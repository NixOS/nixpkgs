{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, webob
}:

buildPythonPackage rec {
  pname = "hawkauthlib";
  version = "0.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "0mr1mpx4j9q7sch9arwfvpysnpf2p7ijy7072wilxm8pnj0bwvsi";
  };

  propagatedBuildInputs = [ requests webob ];

  meta = with lib; {
    homepage = "https://github.com/mozilla-services/hawkauthlib";
    description = "Hawk Access Authentication protocol";
    license = licenses.mpl20;
  };

}
