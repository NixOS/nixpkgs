{ buildDunePackage
, httpun
, gluten-eio
}:

buildDunePackage {
  pname = "httpun-eio";

  inherit (httpun) src version;

  propagatedBuildInputs = [ gluten-eio httpun ];

  meta = httpun.meta // {
    description = "EIO support for httpun";
  };
}
