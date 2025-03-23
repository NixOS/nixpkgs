{
  lib,
  buildPythonPackage,
  flit-core,
  ninja,
}:

buildPythonPackage {
  pname = "ninja";
  inherit (ninja) version;
  format = "pyproject";

  src = ./stub;

  postUnpack = ''
    substituteInPlace "$sourceRoot/pyproject.toml" \
      --subst-var version

    substituteInPlace "$sourceRoot/ninja/__init__.py" \
      --subst-var version \
      --subst-var-by BIN_DIR "${ninja}/bin"
  '';

  inherit (ninja) setupHook;

  nativeBuildInputs = [ flit-core ];

  preBuild = ''
    cp "${ninja.src}/misc/ninja_syntax.py" ninja/ninja_syntax.py
  '';

  pythonImportsCheck = [
    "ninja"
    "ninja.ninja_syntax"
  ];

  meta = with lib; {
    description = "Small build system with a focus on speed";
    mainProgram = "ninja";
    longDescription = ''
      This is a stub of the ninja package on PyPI that uses the ninja program
      provided by nixpkgs instead of downloading ninja from the web.
    '';
    homepage = "https://github.com/scikit-build/ninja-python-distributions";
    license = licenses.asl20;
    maintainers = with maintainers; [
      _999eagle
      tjni
    ];
  };
}
