{ stdenv, fetchFromGitHub, pythonPackages}:

stdenv.mkDerivation rec {
  version = "4.4";
  name = "cxxtest";

  src = fetchFromGitHub {
    owner = "CxxTest";
    repo = name;
    rev = version;
    sha256 = "19w92kipfhp5wvs47l0qpibn3x49sbmvkk91yxw6nwk6fafcdl17";
  };

  buildInputs = with pythonPackages; [ python wrapPython ];

  installPhase = ''
    cd python
    python setup.py install --prefix=$out
    cd ..

    mkdir -p $out/include
    cp -R cxxtest $out/include/

    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    homepage = "http://cxxtest.com";
    description = "Unit testing framework for C++";
    platforms = platforms.unix ;
    license = licenses.lgpl3;
    maintainers = [ maintainers.juliendehos ];
  };
}

