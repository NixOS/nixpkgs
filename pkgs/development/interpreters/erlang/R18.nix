{ mkDerivation, fetchpatch }:

let
  rmAndPwdPatch = fetchpatch {
     url = "https://github.com/erlang/otp/commit/98b8650d22e94a5ff839170833f691294f6276d0.patch";
     sha256 = "0zjs7as83prgq4d5gaw2cmnajnsprdk8cjl5kklknx0pc2b3hfg5";
  };

  envAndCpPatch = fetchpatch {
     url = "https://github.com/erlang/otp/commit/9f9841eb7327c9fe73e84e197fd2965a97b639cf.patch";
     sha256 = "00fx5wc88ki3z71z5q4xzi9h3whhjw1zblpn09w995ygn07m9qhm";
  };

  makeOrderingPatch = fetchpatch {
     url = "https://github.com/erlang/otp/commit/2f1a37f1011ff9d129bc35a6efa0ab937a2aa0e9.patch";
     sha256 = "0xfa6hzxh9d7qllkyidcgh57xrrx11w65y7s1hyg52alm06l6b9n";
  };

  makeParallelInstallPatch = fetchpatch {
     url ="https://github.com/erlang/otp/commit/de8fe86f67591dd992bae33f7451523dab36e5bd.patch";
     sha256 = "1cj9fjhdng6yllajjm3gkk04ag9bwyb3n70hrb5nk6c292v8a45c";
  };

in mkDerivation {
  version = "18.3.4.8";
  sha256 = "16c0h25hh5yvkv436ks5jbd7qmxzb6ndvk64mr404347a20iib0g";

  patches = [
    rmAndPwdPatch
    envAndCpPatch
    makeOrderingPatch
    makeParallelInstallPatch
  ];
}
