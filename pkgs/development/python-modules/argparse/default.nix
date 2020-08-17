{ buildPythonPackage
, fetchurl
, lib
}:
buildPythonPackage rec {
  name = "argparse";
  version = "1.4.0";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/${name}-${version}.tar.gz";
    sha256 = "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4";
};
  format = "setuptools";
  meta = with lib; {
    homepage = "https://github.com/ThomasWaldmann/argparse/";
    license = licenses.psfl;
    description = "Python command-line parsing library";
    maintainers = [ maintainers.koslambrou ];
  };
}
