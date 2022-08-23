{ buildDunePackage
, gen_js_api
}:

buildDunePackage rec {
  pname = "ojs";

  inherit (gen_js_api) version src;

  doCheck = false; # checks depend on gen_js_api, which is a cycle

  minimalOCamlVersion = "4.08";

  meta = {
    inherit (gen_js_api.meta) homepage license maintainers;
    description = "Runtime Library for gen_js_api generated libraries";
    longDescription = ''
      To be used in conjunction with gen_js_api
    '';
  };
}
