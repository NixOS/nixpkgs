{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  pillow,
  toml,
  numpy,
  pyyaml,
  python,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "clickgen";
  version = "2.2.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "clickgen";
    tag = "v${version}";
    hash = "sha256-yFEkE1VyeHBuebpsumc6CTvv2kpAw7XAWlyUlXibqz0=";
  };

  propagatedBuildInputs = [
    attrs
    numpy
    pillow
    pyyaml
    toml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postInstall = ''
    # Copying scripts directory needed by clickgen script at $out/bin/
    cp -R src/clickgen/scripts $out/${python.sitePackages}/clickgen/scripts
  '';

  pythonImportsCheck = [ "clickgen" ];

  meta = {
    homepage = "https://github.com/ful1e5/clickgen";
    description = "Hassle-free cursor building toolbox";
    longDescription = ''
      clickgen is API for building X11 and Windows Cursors from
      .png files. clickgen is using anicursorgen and xcursorgen under the hood.
    '';
    license = lib.licenses.mit;
    maintainers = [ ];
    # fails with:
    # ld: unknown option: -zdefs
    broken = stdenv.hostPlatform.isDarwin;
  };
}
