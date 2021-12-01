{lib, buildOcamlJane, async_kernel, bin_prot, core_kernel,
 fieldslib, ppx_assert, ppx_bench, ppx_driver, ppx_expect, ppx_inline_test,
 ppx_jane, sexplib, typerep, variantslib}:

buildOcamlJane {
  pname = "async_rpc_kernel";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs = [ async_kernel bin_prot core_kernel fieldslib
    ppx_assert ppx_bench ppx_driver ppx_expect ppx_inline_test ppx_jane
    sexplib typerep variantslib ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/async_rpc_kernel";
    description = "Platform-independent core of Async RPC library";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer ];
  };
}
