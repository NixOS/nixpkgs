{ lib, buildPythonPackage, fetchPypi, setuptools, importlib-metadata }:

buildPythonPackage rec {
  pname = "exdown";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hx2qx3bafg5cnk8ibb3plmx60i4z9ryclq6ijh3xm30n6ylhiyf";
  };

  propagatedBuildInputs = [ importlib-metadata ];

  patches = [
    ./add_empty_setup.patch
  ];

  meta = with lib; {
    description = "A tool for extracting code blocks from Markdown files";
    homepage = "https://github.com/nschloe/exdown";
    license = licenses.mit;
    maintainers = [ maintainers.wulfsta ];
  };
}
