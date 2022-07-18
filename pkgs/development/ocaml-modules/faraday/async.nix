{ buildDunePackage, fetchpatch, faraday, core, async }:

buildDunePackage rec {
  pname = "faraday-async";
  inherit (faraday) version src useDune2;

  patches = fetchpatch {
    url = "https://github.com/inhabitedtype/faraday/commit/31c3fc7f91ecca0f1deea10b40fd5e33bcd35f75.patch";
    sha256 = "05z5gk7hxq7qvwg6f73hdhfcnx19p1dq6wqh8prx667y8zsaq2zj";
  };

  minimumOCamlVersion = "4.08";

  propagatedBuildInputs = [ faraday core async ];

  meta = faraday.meta // {
    description = "Async support for Faraday";
  };
}
