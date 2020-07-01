{ stdenv
, buildPythonPackage
, fetchFromGitHub
, numpy
, setuptools
, python
, scikitimage
, openjpeg
, procps
, contextlib2
, mock
, importlib-resources
, isPy27
}:

buildPythonPackage rec {
  pname = "glymur";
  version = "0.8.18";

  src = fetchFromGitHub {
    owner = "quintusdias";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zbghzw1q4fljb019lsrhka9xrnn4425qnxrjbmbv7dssgkkywd7";
  };

  propagatedBuildInputs = [
    numpy
  ] ++ stdenv.lib.optional isPy27 [ contextlib2 mock importlib-resources ];

  checkInputs = [
    scikitimage
    procps
  ];

  postConfigure = ''
    substituteInPlace glymur/config.py \
    --replace "path = read_config_file(libname)" "path = '${openjpeg}/lib' + libname + ${if stdenv.isDarwin then "'.dylib'" else "'.so'"}"
  '';

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    description = "Tools for accessing JPEG2000 files";
    homepage = "https://github.com/quintusdias/glymur";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
