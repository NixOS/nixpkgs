/* This function wraps buildPythonPackage and uses pre-fetched data from PyPI to build a package.
*/
{ buildPythonPackage
, fetchurl
, lib
, filename
# , timestamp ? false
}:

let
  json = builtins.fromJSON (builtins.readFile filename);
  fetcher = pypi: version: fetchurl { inherit (pypi.versions.${version}) url sha256;};

#   latest_version: pypi: timestamp:    filter

in
{ pname
, version ? ""
, ... } @ attrs:

let
  pypi = json.${pname};

  # Whether to actually use PyPI
  use_pypi = !(builtins.hasAttr "src" attrs || builtins.hasAttr "srcs" attrs);

  # Use Meta data from PyPI
  meta = (if use_pypi then (pypi.meta or {}) else {}) // (attrs.meta or {});

  # Version of the package. When it's given, use it.
  # Otherwise, if src is not specified, we use the latest version available via PyPI.
  version = attrs.version or (if use_pypi then pypi.latest_version else "");

#   valid_versions = if timestamp != false

  # Use src if given. Otherwise, pick the right version via PyPI.
  src = attrs.src or attrs.srcs or (fetcher pypi version);

  name = pname + "-" + version;

in buildPythonPackage ( attrs // {inherit name src meta;} )
