{
  buildDunePackage,
  trace,
  mtime,
}:

buildDunePackage {
  pname = "trace-tef";
  inherit (trace) src version;

  __structuredAttrs = true;

  minimalOCamlVersion = "4.12";

  propagatedBuildInputs = [
    mtime
    trace
  ];

  doCheck = true;

  meta = trace.meta // {
    description = "Simple backend for trace, emitting Catapult JSON into a file";
  };

}
