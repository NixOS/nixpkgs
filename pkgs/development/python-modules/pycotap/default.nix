{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

let
  self = buildPythonPackage {
    pname = "pycotap";
    version = "1.3.1";
    pyproject = true;

    src = fetchPypi {
      inherit (self) pname version;
      hash = "sha256-Z0NV8BMAvgPff4cXhOSYZSwtiawZzXfujmFlJjSi+Do=";
    };

    build-system = [ setuptools ];

    postFixup = ''
      rm $out/COPYING
    '';

    meta = {
      homepage = "https://github.com/remko/pycotap";
      description = "Tiny Python TAP Test Runner";
      longDescription = ''
        pycotap is a simple Python test runner for unittest that outputs Test
        Anything Protocol results to standard output (similar to what tape does
        for JavaScript).

        Contrary to other TAP runners for Python, pycotap

        - prints TAP (and only TAP) to standard output instead of to a separate
          file, allowing you to pipe it directly to TAP pretty printers and
          processors (such as the ones listed on the tape page). By piping it to
          other consumers, you can avoid the need to add specific test runners
          to your test code. Since the TAP results are printed as they come in,
          the consumers can directly display results while the tests are run.

        - only contains a TAP reporter, so no parsers, no frameworks, no
          dependencies ...
        - is configurable: you can choose how you want the test output and test
          result diagnostics to end up in your TAP output (as TAP diagnostics,
          YAML blocks, or attachments). The defaults are optimized for a Jenkins
          based flow.

        > Nice work with pycotap! I took a "kitchen sink" approach with tappy so
        > I'm glad someone made a no dependency TAP unittest runner. :) -- Matt
        > Layman, author of tappy
      '';
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ mwolfe AndersonTorres ];
    };
  };
in
self
