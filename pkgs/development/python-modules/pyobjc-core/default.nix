{
  buildPythonPackage,
  darwin,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyobjc-core";
  version = "11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = "pyobjc";
    tag = "v${version}";
    hash = "sha256-RhB0Ht6vyDxYwDGS+A9HZL9ySIjWlhdB4S+gHxvQQBg=";
  };

  sourceRoot = "source/pyobjc-core";

  build-system = [ setuptools ];

  buildInputs = [
    darwin.DarwinTools
    darwin.libffi
  ];

  nativeBuildInputs = [
    darwin.DarwinTools # sw_vers
  ];

  # See https://github.com/ronaldoussoren/pyobjc/pull/641. Unfortunately, we
  # cannot just pull that diff with fetchpatch due to https://discourse.nixos.org/t/how-to-apply-patches-with-sourceroot/59727.
  postPatch = ''
    for file in Modules/objc/test/*.m; do
      substituteInPlace "$file" --replace "[[clang::suppress]]" ""
    done

    substituteInPlace setup.py \
      --replace-fail "-buildversion" "-buildVersion" \
      --replace-fail "-productversion" "-productVersion"
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${darwin.libffi.dev}/include"
    "-Wno-error=cast-function-type-mismatch"
    "-Wno-error=unused-command-line-argument"
  ];

  pythonImportsCheck = [ "objc" ];

  meta = with lib; {
    description = "Python <-> Objective-C bridge";
    homepage = "https://github.com/ronaldoussoren/pyobjc";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ samuela ];
  };
}
