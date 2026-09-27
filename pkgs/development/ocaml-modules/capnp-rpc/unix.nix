{
  buildDunePackage,
  alcotest,
  astring,
  base64,
  capnp,
  capnp-rpc,
  capnp-rpc-net,
  capnproto,
  cmdliner,
  cstruct,
  eio,
  eio_main,
  fmt,
  ipaddr,
  logs,
  mdx,
  mirage-crypto-rng,
}:

buildDunePackage (finalAttrs: {
  pname = "capnp-rpc-unix";

  minimalOCamlVersion = "5.2";

  inherit (capnp-rpc) src version;

  nativeBuildInputs = [
    capnp
    capnproto
  ];

  propagatedBuildInputs = [
    astring
    base64
    capnp-rpc
    capnp-rpc-net
    cmdliner
    cstruct
    eio
    fmt
    ipaddr
    logs
    mirage-crypto-rng
  ];

  checkInputs = [
    alcotest
    eio_main
    (mdx.override { inherit logs; })
  ];

  nativeCheckInputs = [ mdx.bin ];

  doCheck = true;

  preCheck = ''
    export XDG_CACHE_HOME="$TMPDIR/cache"
  '';

  meta = capnp-rpc.meta // {
    description = "Unix helpers for Cap'n Proto RPC services";
  };
})
