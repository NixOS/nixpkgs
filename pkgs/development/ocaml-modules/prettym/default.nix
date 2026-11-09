{
  alcotest,
  base64,
  buildDunePackage,
  fetchurl,
  jsonm,
  ke,
  bstr,
  lib,
  ptime,
}:

buildDunePackage (finalAttrs: {
  pname = "prettym";
  version = "0.0.5";

  src = fetchurl {
    url = "https://github.com/dinosaure/prettym/releases/download/${finalAttrs.version}/prettym-${finalAttrs.version}.tbz";
    hash = "sha256-2sFZmW8HqSTF9UQZU6lcxipLX17txJwxZZIRr/CT1GI=";
  };

  propagatedBuildInputs = [
    bstr
    ke
  ];

  checkInputs = [
    ptime
    alcotest
    jsonm
    base64
  ];
  doCheck = true;

  meta = {
    description = "Simple bounded encoder to serialize human readable values and respect the 80-column constraint";
    license = lib.licenses.mit;
    homepage = "https://github.com/dinosaure/prettym";
    changelog = "https://github.com/dinosaure/prettym/releases/tag/${finalAttrs.version}";
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
