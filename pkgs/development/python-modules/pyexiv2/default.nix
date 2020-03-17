{ stdenv, isPy27, buildPythonPackage, fetchFromGitHub, python, exiv2, pybind11, pytest, psutil }:

buildPythonPackage rec {
  pname = "pyexiv2";
  version = "2.1.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "LeoHsiao1";
    repo = pname;
    rev = "v${version}";
    sha256 = "1isgrd2d5hhqc6s7yr3mnhzyyf4gm31d3ryxf3wlr39bmn59b09i";
  };

  buildInputs = [ python exiv2 pybind11 ];

  checkInputs = [ pytest psutil ];

  postPatch = ''
    # Remove pre-compiled binaries from source.
    find . "(" -name "*.so" -o -name "*.dll" -o -name "*.pyd" ")" -delete
  '';

  preBuild = ''
    PYTHON_VERSION="$(python -c "import platform; print(str().join(platform.python_version_tuple()[:2]))")"
    PYBIND_INCLUDES="$(python -m pybind11 --includes)"
    SOURCE_FILE="$src/pyexiv2/lib/exiv2api.cpp"
    OUTPUT_FILE="./pyexiv2/lib/linux64-py$PYTHON_VERSION/exiv2api.so"

    CXXFLAGS="-O3 -Wall -std=c++11 $PYBIND_INCLUDES"
    LDFLAGS="-shared -fPIC -lexiv2"

    # Compile native code portion. NOTE: there is no script/build file.
    $CXX "$SOURCE_FILE" -o "$OUTPUT_FILE" $CXXFLAGS $LDFLAGS

    # XXX: pyexiv2 needs libexiv2 in its own library directory.
    ln -sf "${exiv2.out}/lib/libexiv2.so" "./pyexiv2/lib/libexiv2.so"
  '';

  checkPhase = ''
    pushd pyexiv2/tests
    pytest
    popd
  '';

  meta = with stdenv.lib; {
    description = "Python bindings for exiv2, for reading/writing EXIF data.";
    homepage = "https://github.com/LeoHsiao1/pyexiv2";
    license = licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ jchw ];
  };
}
