{stdenv, buildOcamlJane, fetchurl, async_kernel, async_unix,
 bin_prot, core, ppx_custom_printf, fieldslib, herelib,
 pipebang, sexplib, async_rpc_kernel}:

buildOcamlJane rec {
  name = "async_extra";
  hash = "1xdwab19fycr4cdm3dh9vmx42f8lvf9s4f9pjgdydxfrm7yzyrfh";
  propagatedBuildInputs = [ async_kernel async_unix core bin_prot ppx_custom_printf
                            fieldslib herelib pipebang sexplib async_rpc_kernel ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_extra;
    description = "Jane Street Capital's asynchronous execution library (extra)";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
