{
  lib,
  fetchurl,
  buildDunePackage,
  logs,
  fmt,
  alcotest,
  qcheck,
  qcheck-alcotest,
  ppx_expect,
  mdx,
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml";
  version = "3.0.0";

  minimalOCamlVersion = "5.1.1";

  src = fetchurl {
    url = "https://github.com/xhtmlboi/yocaml/releases/download/v${finalAttrs.version}/yocaml-${finalAttrs.version}.tbz";
    hash = "sha256-xSN8XzRfdsgp/Z9OxfzQUFHm9DcrJOz3mKSMJknOmg4=";
  };

  propagatedBuildInputs = [
    logs
  ];

  doCheck = true;
  nativeCheckInputs = [
    mdx.bin
  ];
  checkInputs = [
    alcotest
    fmt
    (mdx.override { inherit logs; })
    ppx_expect
    qcheck-alcotest
    qcheck
  ];

  meta = {
    homepage = "https://github.com/xhtmlboi/yocaml";
    description = "Framework for creating static site generators";
    changelog = "https://github.com/xhtmlboi/yocaml/blob/main/CHANGES.md";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rpqt ];
  };
})
