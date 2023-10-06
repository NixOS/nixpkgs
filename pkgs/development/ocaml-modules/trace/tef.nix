{ buildDunePackage, trace, mtime }:

buildDunePackage {
  pname = "trace-tef";
  inherit (trace) src version;

  propagatedBuildInputs = [ mtime trace ];

  doCheck = true;

  meta = trace.meta // {
    description = "A simple backend for trace, emitting Catapult JSON into a file";
  };

}
