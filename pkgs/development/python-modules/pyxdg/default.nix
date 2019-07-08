{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyxdg";
  version = "0.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://freedesktop.org/wiki/Software/pyxdg;
    description = "Contains implementations of freedesktop.org standards";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
