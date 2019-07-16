{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "pex";
  version = "1.6.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hg30y8b4b96r4skhz2qmsp7li1izcg8854q3fi48rks0kcfx5fw";
  };

  nativeBuildInputs = [ setuptools ];

  # A few more dependencies I don't want to handle right now...
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
