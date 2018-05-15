{ stdenv, buildPythonPackage, fetchPypi, logilab_common, six }:

buildPythonPackage rec {
  pname = "logilab-constraint";
  version = "0.6.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n0xim4ij1n4yvyqqvyc0wllhjs22szglsd5av0j8k2qmck4njcg";
  };

  propagatedBuildInputs = [
    logilab_common six
  ];


  meta = with stdenv.lib; {
    description = "logilab-database provides some classes to make unified access to different";
    homepage = "https://www.logilab.org/project/logilab-database";
  };
}

