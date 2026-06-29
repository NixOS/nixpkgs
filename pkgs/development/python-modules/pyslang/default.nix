{
  lib,
  buildPythonPackage,
  sv-lang,
  python,
}:
buildPythonPackage {
  pname = "pyslang";
  version = sv-lang.version;
  format = "other";

  disabled = python.pythonVersion != sv-lang.pythonVersion;

  src = sv-lang;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/${python.sitePackages}
    cp $src/pyslang.*.so $out/${python.sitePackages}/
  '';

  pythonImportsCheck = [ "pyslang" ];

  meta = sv-lang.meta // {
    description = "Python bindings for the slang SystemVerilog parser.";
    maintainers = with lib.maintainers; [ hugom ];
  };
}
