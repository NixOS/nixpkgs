{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "requests_download";
  version = "0.1.1";
  name = "${pname}-${version}";

  format = "wheel";

  #src = pkgs.fetchurl {
  #  url = https://files.pythonhosted.org/packages/60/af/10f899f0574a81cbc511124c08d7c7dc46c20d4f956a6a3c793ad4330bb4/requests_download-0.1.1-py2.py3-none-any.whl;
  #  sha256 = "07832a93314bcd619aaeb08611ae245728e66672efb930bc2a300a115a47dab7";
  #};

  src = fetchPypi {
    inherit pname version format;
    sha256 = "07832a93314bcd619aaeb08611ae245728e66672efb930bc2a300a115a47dab7";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "Download files using requests and save them to a target path";
    homepage = https://www.github.com/takluyver/requests_download;
    license = lib.licenses.mit;
    maintainer = lib.maintainers.fridh;
  };
}