{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1092ae52cfdef41c22d98fa98f9225ac21936a7d096131777ca3a7940fe1b2d";
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
