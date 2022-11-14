{ lib, python3Packages }:

with python3Packages;
buildPythonPackage rec {
  pname = "doq";
  version = "0.9.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "baccc348ddf967c8bf32bfdf54da8326e1dc74f37865e2c176012ad0bc7eea1e";
  };

  propagatedBuildInputs = [ toml parso jinja2 ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/heavenshell/py-doq";
    description = "Docstring generator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ v1kko ];
  };
}
