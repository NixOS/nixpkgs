{
  buildPythonPackage,
  setuptools,
  fetchurl,
  writeText,

  ament-lint,

  libxml2, # xmllint inside

  ament-copyright,
  ament-flake8,
  ament-pep257,
  pytestCheckHook,
}:
let
  packageFormat2Xsd = fetchurl {
    url = "http://download.ros.org/schema/package_format2.xsd";
    hash = "sha256-pzKK8IWbPxWuTwSRLYRqWO3GZk2x5pr/BhsilAwZQwQ=";
  };
  packageFormat3Xsd = fetchurl {
    url = "http://download.ros.org/schema/package_format3.xsd";
    hash = "sha256-WFIBgJy/jIHsWk19hNgn9Gdt1ipLwKgS2npIXeoq1Do=";
  };

  rosPackageCatalog = writeText "ros-packages-catalog.xml" ''
    <?xml version="1.0"?>
    <!DOCTYPE catalog PUBLIC "-//OASIS//DTD XML Catalogs V1.1//EN" "http://www.oasis-open.org/committees/entity/release/1.1/catalog.dtd">
    <catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">
      <uri name="http://download.ros.org/schema/package_format2.xsd" uri="${packageFormat2Xsd}"/>
      <uri name="http://download.ros.org/schema/package_format3.xsd" uri="${packageFormat3Xsd}"/>
    </catalog>
  '';
in
buildPythonPackage (finalAttrs: {
  pname = "ament-xmllint";
  pyproject = true;

  inherit (ament-lint) version src;

  sourceRoot = "${finalAttrs.src.name}/ament_xmllint";

  postPatch = ''
    substituteInPlace ament_xmllint/main.py --replace-fail \
      "cmd, cwd" \
      "cmd, env={'XML_CATALOG_FILES': '${rosPackageCatalog}', **os.environ}, cwd"
  '';

  build-system = [ setuptools ];

  propagatedNativeBuildInputs = [ libxml2.bin ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    ament-copyright
    ament-flake8
    ament-pep257
  ];

  disabledTests = [ "test_flake8" ]; # line too long because catalog path in patch

  strictDeps = true;
  __structuredAttrs = true;

  passthru = { inherit rosPackageCatalog; };

  meta = {
    inherit (ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to check XML files like the package manifest using xmllint and generate xUnit test result files";
    mainProgram = "ament_xmllint";
  };
})
