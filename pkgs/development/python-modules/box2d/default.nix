{ stdenv
, buildPythonPackage
, fetchPypi
, swig2
, isPy3k
}:

buildPythonPackage rec {
  pname = "Box2D";
  version = "2.3.2";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1557dffdf9c1d6c796ec5df53e3d93227bb026c14b8411d22c295edaa2fb225";
  };

  postPatch = ''
    sed -i "s/'Box2D.tests' : 'tests'//" setup.py
  '';

  nativeBuildInputs = [ swig2 ];

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/pybox2d/pybox2d;
    description = ''
      A 2D game physics library for Python under
      the very liberal zlib license
    '';
    license = licenses.zlib;
    maintainers = with maintainers; [ sepi ];
  };
}
