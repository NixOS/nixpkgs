{
  buildPythonPackage,
  lib,
  fetchhg,
  parse,
}:

buildPythonPackage rec {
  pname = "pyparser";
  version = "1.0";
  format = "setuptools";

  # Missing tests on Pypi
  src = fetchhg {
    url = "https://keep.imfreedom.org/grim/pyparser";
    rev = "v${version}";
    hash = "sha256-DoKYZHSyysRsuDTUQPXhBacb8ckbSJy4qne92z5Z9Co=";
  };

  postPatch = "sed -i 's/parse==/parse>=/' requirements.txt";

  propagatedBuildInputs = [ parse ];

  meta = {
    description = "Simple library that makes it easier to parse files";
    homepage = "https://keep.imfreedom.org/grim/pyparser";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
