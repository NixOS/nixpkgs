{
  mkPythonMetaPackage,
  psycopg2,
}:
mkPythonMetaPackage {
  pname = "psycopg2-binary";
  inherit (psycopg2) version;
  dependencies = [ psycopg2 ];
  optional-dependencies = psycopg2.optional-dependencies or { };
  meta = {
    inherit (psycopg2.meta) description homepage;
  };
}
