{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, python
, ninja
, scikit-build
, setuptools
, wheel
, robin-map
}:

buildPythonPackage rec {
  pname = "nanobind";
  version = "unstable-2023-11-16";
  format = "other";

  src = fetchFromGitHub {
    owner = "wjakob";
    repo = "nanobind";
    # Use HEAD until there's a tag that includes https://github.com/wjakob/nanobind/pull/356
    rev = "ea2569f705b9d12185eea67db399a373d37c75aa";
    hash = "sha256-f4Y/roXSOSXIHCSyoS+RzBZdxJe6tIz6yAKZl4gDmz8=";
  };

  # Work around https://github.com/wjakob/nanobind/blob/ea2569f705b9d12185eea67db399a373d37c75aa/CMakeLists.txt#L50C29-L50C50
  postPatch = ''
    substituteInPlace src/__init__.py \
      --replace \
        "os.path.dirname(__file__)" \
        "\"$out/share/nanobind\""
  '';

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build
    setuptools
    wheel
  ];

  buildInputs = [
    robin-map
  ];

  cmakeFlags = [
    (lib.cmakeBool "NB_USE_SUBMODULE_DEPS" false)
  ];

  postInstall = ''
    mkdir -p $out/${python.sitePackages}/nanobind/
    cp ../src/*.py $out/${python.sitePackages}/nanobind/
  '';

  pythonImportsCheck = [ "nanobind" ];

  meta = with lib; {
    description = "Nanobind: tiny and efficient C++/Python bindings";
    homepage = "https://github.com/wjakob/nanobind";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
