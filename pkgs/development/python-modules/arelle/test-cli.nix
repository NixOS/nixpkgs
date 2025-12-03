# Run with:
#   cd nixpkgs
#   nix-build -A python3Packages.arelle.passthru.tests.cli
#
# Note: These are uninteresting generated smoke tests to verify basic functionality
{
  lib,
  runCommand,
  arelle,
}:

runCommand "arelle-test-cli${lib.optionalString (!arelle.hasGUI) "-headless"}"
  {
    nativeBuildInputs = [ arelle ];
  }
  ''
    # Set up temporary home directory
    export HOME=$(mktemp -d)

    # Test basic CLI commands work with proper assertions
    arelleCmdLine --version --disablePersistentConfig 2>&1 | grep "Arelle(r) ${arelle.version}" > /dev/null
    arelleCmdLine --help --disablePersistentConfig 2>&1 | grep "Usage: arelleCmdLine \[options\]" > /dev/null
    arelleCmdLine --about --disablePersistentConfig 2>&1 | grep "An open source XBRL platform" > /dev/null

    ${lib.optionalString arelle.hasGUI ''
      # check if the arelleGUI command is available
      command -v arelleGUI
    ''}

    # Create a simple but valid XBRL instance for testing validation functionality
    cat > test-instance.xbrl << 'EOF'
    <?xml version="1.0" encoding="UTF-8"?>
    <xbrl xmlns="http://www.xbrl.org/2003/instance"
          xmlns:link="http://www.xbrl.org/2003/linkbase"
          xmlns:xlink="http://www.w3.org/1999/xlink">

      <link:schemaRef xlink:href="http://www.xbrl.org/2003/xbrl-instance-2003-12-31.xsd" xlink:type="simple"/>

      <context id="test_context">
        <entity>
          <identifier scheme="http://example.com/entities">TEST_ENTITY</identifier>
        </entity>
        <period>
          <instant>2023-12-31</instant>
        </period>
      </context>

    </xbrl>
    EOF

    # Also create a minimal test schema for more comprehensive testing
    cat > test-schema.xsd << 'EOF'
    <?xml version="1.0" encoding="UTF-8"?>
    <schema xmlns="http://www.w3.org/2001/XMLSchema"
            xmlns:xbrli="http://www.xbrl.org/2003/instance"
            xmlns:link="http://www.xbrl.org/2003/linkbase"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:test="http://example.com/test"
            targetNamespace="http://example.com/test"
            elementFormDefault="qualified">

      <import namespace="http://www.xbrl.org/2003/instance"
              schemaLocation="http://www.xbrl.org/2003/xbrl-instance-2003-12-31.xsd"/>

      <element name="TestElement" type="xbrli:stringItemType"
                substitutionGroup="xbrli:item" xbrli:periodType="instant"/>

    </schema>
    EOF

    # Test XBRL validation functionality
    arelleCmdLine \
      --file test-instance.xbrl \
      --validate \
      --disablePersistentConfig \
      --internetConnectivity=offline \
      --logLevel=info 2>&1 | grep "\[info\] validated in .* secs - .*test-instance.xbrl" > /dev/null

    # Test with the built-in empty instance from arelle config
    arelleCmdLine \
      --file "${arelle}/lib/python3.13/site-packages/arelle/config/empty-instance.xml" \
      --validate \
      --disablePersistentConfig \
      --internetConnectivity=offline \
      --logLevel=info 2>&1 | grep "\[info\] validated in .* secs - .*empty-instance.xml" > /dev/null

    # Test formula functionality (without running - just checking it loads)
    arelleCmdLine \
      --file test-instance.xbrl \
      --formula=none \
      --disablePersistentConfig \
      --internetConnectivity=offline 2>&1 | grep "\[info\] loaded in .* secs.*test-instance.xbrl" > /dev/null

    # Test facts output functionality
    TEMP_DIR=$(mktemp -d)
    arelleCmdLine \
      --file test-instance.xbrl \
      --facts="$TEMP_DIR/test-facts.csv" \
      --disablePersistentConfig \
      --internetConnectivity=offline 2>&1 | grep "\[info\] loaded in .* secs.*test-instance.xbrl" > /dev/null

    # Test schema validation
    arelleCmdLine \
      --file test-schema.xsd \
      --validate \
      --disablePersistentConfig \
      --internetConnectivity=offline \
      --logLevel=info 2>&1 | grep "\[info\] validated in .* secs - .*test-schema.xsd" > /dev/null

    # Test disclosure system validation option
    arelleCmdLine \
      --disclosureSystem=help \
      --disablePersistentConfig 2>&1 | grep "Disclosure system choices:" > /dev/null

    # Create success marker
    touch $out
  ''
