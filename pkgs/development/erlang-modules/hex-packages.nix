/* hex-packages.nix is an auto-generated file -- DO NOT EDIT! */

/* Unbuildable packages: 

 * active_0_9_0
 * amqp_client_3_5_6
 * aws_http_0_2_4
 * barrel_jiffy_0_14_4
 * barrel_jiffy_0_14_5
 * cache_tab_1_0_1
 * certifi_0_1_1
 * cet_0_2_1
 * cloudi_core_1_4_0_rc_4
 * cloudi_core_1_5_1
 * cloudi_service_api_requests_1_5_1
 * cloudi_service_db_1_5_1
 * cloudi_service_db_cassandra_1_3_3
 * cloudi_service_db_cassandra_cql_1_5_1
 * cloudi_service_db_couchdb_1_5_1
 * cloudi_service_db_elasticsearch_1_3_3
 * cloudi_service_db_http_elli_1_5_1
 * cloudi_service_db_memcached_1_5_1
 * cloudi_service_db_mysql_1_5_1
 * cloudi_service_db_pgsql_1_5_1
 * cloudi_service_db_riak_1_3_3
 * cloudi_service_db_tokyotyrant_1_5_0
 * cloudi_service_filesystem_1_5_1
 * cloudi_service_http_client_1_5_1
 * cloudi_service_http_cowboy_1_5_1
 * cloudi_service_http_rest_1_5_1
 * cloudi_service_map_reduce_1_5_1
 * cloudi_service_monitoring_1_5_1
 * cloudi_service_queue_1_5_1
 * cloudi_service_quorum_1_5_1
 * cloudi_service_router_1_5_1
 * cloudi_service_tcp_1_5_1
 * cloudi_service_timers_1_5_1
 * cloudi_service_udp_1_5_1
 * cloudi_service_validate_1_5_1
 * cloudi_service_zeromq_1_5_1
 * cmark_0_6_2
 * comeonin_2_0_1
 * conferl_0_0_1
 * couchbeam_1_2_1
 * cowboy_1_0_4
 * cpg_1_4_0
 * cpg_1_5_1
 * craterl_0_2_3
 * cucumberl_0_0_6
 * db_0_9_0
 * ddb_client_0_1_17
 * denrei_0_2_3
 * dproto_0_1_12
 * dqe_0_1_22
 * ekstat_0_2_2
 * elibphonenumber_0_1_1
 * elli_1_0_4
 * enotify_0_1_0
 * ensq_0_1_6
 * eplugin_0_1_4
 * epubnub_0_1_0
 * eredis_cluster_0_5_4
 * erlang_lua_0_1_0
 * erlastic_search_1_1_1
 * erlaudio_0_2_3
 * erlcloud_0_12_0
 * erltrace_0_1_4
 * escalus_2_6_4
 * ex_bitcask_0_1_0
 * ezmq_0_2_0
 * fast_tls_1_0_0
 * fast_xml_1_1_2
 * fast_yaml_1_0_1
 * fifo_utils_0_1_18
 * folsom_ddb_0_1_20
 * fqc_0_1_7
 * gpb_3_18_10
 * gpb_3_18_8
 * hackney_1_1_0
 * hackney_1_3_1
 * hackney_1_3_2
 * hackney_1_4_4
 * hackney_1_4_8
 * hash_ring_ex_1_1_2
 * jc_1_0_4
 * jose_1_4_2
 * jsx_2_7_2
 * jsxn_0_2_1
 * katipo_0_2_4
 * kvs_2_1_0
 * lager_2_1_1
 * lager_watchdog_0_1_10
 * lasp_0_0_3
 * libleofs_0_1_2
 * locker_1_0_8
 * mad_0_9_0
 * mcrypt_0_1_0
 * mdns_client_0_1_7
 * mdns_client_lib_0_1_33
 * mimerl_1_0_0
 * mmath_0_1_15
 * mmath_0_1_16
 * msgpack_0_4_0
 * mstore_0_1_9
 * n2o_2_3_0
 * nacl_0_3_0
 * neotoma_1_7_3
 * nodefinder_1_4_0
 * nodefinder_1_5_1
 * observer_cli_1_0_3
 * p1_stringprep_1_0_0
 * p1_utils_1_0_0
 * p1_utils_1_0_1
 * p1_utils_1_0_2
 * p1_utils_1_0_3
 * p1_xml_1_1_1
 * parse_trans_2_9_0
 * picosat_0_1_0
 * png_0_1_1
 * pooler_1_4_0
 * protobuffs_0_8_2
 * rankmatcher_0_1_2
 * rebar3_abnfc_plugin_0_1_0
 * rebar3_auto_0_3_0
 * rebar3_eqc_0_0_8
 * rebar3_exunit_0_1_1
 * rebar3_live_0_1_3
 * rebar3_neotoma_plugin_0_2_0
 * rebar3_proper_0_5_0
 * rebar3_proper_plugin_0_1_0
 * rebar3_protobuffs_0_2_0
 * rebar3_run_0_2_0
 * rebar3_yang_plugin_0_2_1
 * rebar_protobuffs_0_1_0
 * relflow_1_0_4
 * reup_0_1_0
 * riak_pb_2_1_0
 * riakc_2_1_1
 * service_1_5_1
 * sfmt_0_12_8
 * siphash_2_1_1
 * snappy_1_1_1
 * stun_1_0_0
 * syslog_1_0_2
 * ucol_nif_1_1_5
 * ui_0_1_1
 * uuid_erl_1_4_0
 * uuid_erl_1_5_1
 * xref_runner_0_2_5
 * yomel_0_5_0

*/
{ stdenv, callPackage }:

let
  self = rec {
    backoff_1_1_3 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "backoff";
	    version = "1.1.3";
	    sha256 =
	      "30cead738d20e4c8d36cd37857dd5e23aeba57cb868bf64766d47d371422bdff";
	      
	    meta = {
	      description = "Exponential backoffs library";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/ferd/backoff";
	    };
	  }
      ) {};
    
    backoff = backoff_1_1_3;
    
    barrel_ibrowse_4_2_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "barrel_ibrowse";
	    version = "4.2.0";
	    sha256 =
	      "58bd9e45932c10fd3d0ceb5c4e47952c3243ea300b388192761ac20be197b2ca";
	      
	    meta = {
	      description = "Erlang HTTP client application";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/barrel-db/ibrowse";
	    };
	  }
      ) {};
    
    barrel_ibrowse = barrel_ibrowse_4_2_0;
    
    barrel_oauth_1_6_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "barrel_oauth";
	    version = "1.6.0";
	    sha256 =
	      "b2a800b771d45f32a9a55d416054b3bdfab3a925b62e8000f2c08b719390d4dd";
	      
	    meta = {
	      description = "An Erlang OAuth 1.0 implementation";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/barrel-db/erlang-oauth";
	    };
	  }
      ) {};
    
    barrel_oauth = barrel_oauth_1_6_0;
    
    base16_1_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "base16";
	    version = "1.0.0";
	    sha256 =
	      "02afd0827e61a7b07093873e063575ca3a2b07520567c7f8cec7c5d42f052d76";
	      
	    meta = {
	      description = "Base16 encoding and decoding";
	      license = with stdenv.lib.licenses; [ bsd3 free ];
	      homepage = "https://github.com/goj/base16";
	    };
	  }
      ) {};
    
    base16 = base16_1_0_0;
    
    base64url_0_0_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "base64url";
	    version = "0.0.1";
	    sha256 =
	      "fab09b20e3f5db886725544cbcf875b8e73ec93363954eb8a1a9ed834aa8c1f9";
	      
	    meta = {
	      description = "URL safe base64-compatible codec";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/dvv/base64url";
	    };
	  }
      ) {};
    
    base64url = base64url_0_0_1;
    
    bbmustache_1_0_4 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "bbmustache";
	    version = "1.0.4";
	    sha256 =
	      "03b0d47db66e86df993896dce7578d7e4aae5f84636809b45fa8a3e34ee59b12";
	      
	    meta = {
	      description =
		"Binary pattern match Based Mustache template engine for Erlang/OTP";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/soranoba/bbmustache";
	    };
	  }
      ) {};
    
    bbmustache_1_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "bbmustache";
	    version = "1.1.0";
	    sha256 =
	      "aa22469836bb8a9928ad741bdd2038d49116228bfbe0c2d6c792e1bdd4b256d9";
	      
	    meta = {
	      description =
		"Binary pattern match Based Mustache template engine for Erlang/OTP";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/soranoba/bbmustache";
	    };
	  }
      ) {};
    
    bbmustache = bbmustache_1_1_0;
    
    bear_0_8_3 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "bear";
	    version = "0.8.3";
	    sha256 =
	      "0a04ce4702e00e0a43c0fcdd63e38c9c7d64dceb32b27ffed261709e7c3861ad";
	      
	    meta = {
	      description = "Statistics functions for Erlang";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/puzza007/bear";
	    };
	  }
      ) {};
    
    bear = bear_0_8_3;
    
    bstr_0_3_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "bstr";
	    version = "0.3.0";
	    sha256 =
	      "0fb4e05619663d48dabcd21023915741277ba392f2a5710dde7ab6034760284d";
	      
	    meta = {
	      description = "Erlang library that uses binaries as strings";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/jcomellas/bstr";
	    };
	  }
      ) {};
    
    bstr = bstr_0_3_0;
    
    certifi_0_3_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "certifi";
	    version = "0.3.0";
	    sha256 =
	      "42ae85fe91c038a634a5fb8d0c77f4fc581914c508f087c7138e9366a1517f6a";
	      
	    meta = {
	      description = "An OTP library";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/certifi/erlang-certifi";
	    };
	  }
      ) {};
    
    certifi = certifi_0_3_0;
    
    cf_0_1_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "cf";
	    version = "0.1.2";
	    sha256 =
	      "c86f56bca74dd3616057b28574d920973fe665ecb064aa458dc6a2447f3f4924";
	      
	    meta = {
	      description = "Terminal colour helper";
	      license = stdenv.lib.licenses.mit; 
	    };
	  }
      ) {};
    
    cf_0_2_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "cf";
	    version = "0.2.1";
	    sha256 =
	      "baee9aa7ec2dfa3cb4486b67211177caa293f876780f0b313b45718edef6a0a5";
	      
	    meta = {
	      description = "Terminal colour helper";
	      license = stdenv.lib.licenses.mit; 
	    };
	  }
      ) {};
    
    cf = cf_0_2_1;
    
    cowlib_1_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "cowlib";
	    version = "1.0.0";
	    sha256 =
	      "4dacd60356177ec8cf93dbff399de17435b613f3318202614d3d5acbccee1474";
	      
	    meta = {
	      description = "Support library for manipulating Web protocols";
	      license = stdenv.lib.licenses.isc;
	      homepage = "https://github.com/ninenines/cowlib";
	    };
	  }
      ) {};
    
    cowlib_1_0_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "cowlib";
	    version = "1.0.2";
	    sha256 =
	      "db622da03aa039e6366ab953e31186cc8190d32905e33788a1acb22744e6abd2";
	      
	    meta = {
	      description = "Support library for manipulating Web protocols";
	      license = stdenv.lib.licenses.isc;
	      homepage = "https://github.com/ninenines/cowlib";
	    };
	  }
      ) {};
    
    cowlib_1_3_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "cowlib";
	    version = "1.3.0";
	    sha256 =
	      "2b1ac020ec92e7a59cb7322779870c2d3adc7c904ecb3b9fa406f04dc9816b73";
	      
	    meta = {
	      description = "Support library for manipulating Web protocols";
	      license = stdenv.lib.licenses.isc;
	      homepage = "https://github.com/ninenines/cowlib";
	    };
	  }
      ) {};
    
    cowlib = cowlib_1_3_0;
    
    crc_0_3_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "crc";
	    version = "0.3.0";
	    sha256 =
	      "23d7cb6a18cca461f46f5a0f341c74fd0a680cdae62460687f1a24f0a7faabd4";
	      
	    meta = {
	      description =
		"A library used to calculate CRC checksums for binary data";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/TattdCodeMonkey/crc";
	    };
	  }
      ) {};
    
    crc = crc_0_3_0;
    
    crypto_rsassa_pss_1_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "crypto_rsassa_pss";
	    version = "1.0.0";
	    sha256 =
	      "d8f48874dbef940a8954126249499714e702d8ae0a8f23230a6c2f4a92833313";
	      
	    meta = {
	      description =
		"RSASSA-PSS Public Key Cryptographic Signature Algorithm for Erlang";
	      license = stdenv.lib.licenses.free;
	      homepage =
		"https://github.com/potatosalad/erlang-crypto_rsassa_pss";
	    };
	  }
      ) {};
    
    crypto_rsassa_pss = crypto_rsassa_pss_1_0_0;
    
    cth_readable_1_2_0 = callPackage
      (
	{ buildHex, cf_0_2_1 }:
	  buildHex {
	    name = "cth_readable";
	    version = "1.2.0";
	    sha256 =
	      "41dee2a37e0f266c590b3ea9542ca664e84ebc781a3949115eba658afc08026d";
	     
	    erlangDeps  = [ cf_0_2_1 ];
	    
	    meta = {
	      description = "Common Test hooks for more readable logs";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/ferd/cth_readable";
	    };
	  }
      ) {};
    
    cth_readable = cth_readable_1_2_0;
    
    detergent_0_3_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "detergent";
	    version = "0.3.0";
	    sha256 =
	      "510cfb5d35b4b344762f074b73c8696b4bdde654ea046b3365cf92760ae33362";
	      
	    meta = {
	      description = "An emulsifying Erlang SOAP library";
	      license = with stdenv.lib.licenses; [ unlicense bsd3 ];
	      homepage = "https://github.com/devinus/detergent";
	    };
	  }
      ) {};
    
    detergent = detergent_0_3_0;
    
    dflow_0_1_5 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "dflow";
	    version = "0.1.5";
	    sha256 =
	      "f08e73f22d4c620ef5f358a0b40f8fe3b91219ca3922fbdbe7e42f1cb58f737e";
	      
	    meta = {
	      description = "Pipelined flow processing engine";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/dalmatinerdb/dflow";
	    };
	  }
      ) {};
    
    dflow = dflow_0_1_5;
    
    discount_0_7_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "discount";
	    version = "0.7.0";
	    sha256 =
	      "a37b7890620f93aa2fae06eee364cd906991588bc8897e659f51634179519c97";
	      
	    meta = {
	      description = "Elixir NIF for discount, a Markdown parser";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/asaaki/discount.ex";
	    };
	  }
      ) {};
    
    discount = discount_0_7_0;
    
    dynamic_compile_1_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "dynamic_compile";
	    version = "1.0.0";
	    sha256 =
	      "eb73d8e9a6334914f79c15ee8214acad9659c42222d49beda3e8b6f6789a980a";
	      
	    meta = {
	      description =
		"compile and load erlang modules from string input";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/okeuday/dynamic_compile";
	    };
	  }
      ) {};
    
    dynamic_compile = dynamic_compile_1_0_0;
    
    econfig_0_7_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "econfig";
	    version = "0.7.1";
	    sha256 =
	      "b11d68e3d288b5cb4bd34e668e03176c4ea42790c09f1f449cdbd46a649ea7f3";
	      
	    meta = {
	      description = "simple Erlang config handler using INI files";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/benoitc/econfig";
	    };
	  }
      ) {};
    
    econfig = econfig_0_7_1;
    
    edown_0_7_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "edown";
	    version = "0.7.0";
	    sha256 =
	      "6d7365a7854cd724e8d1fd005f5faa4444eae6a87eb6df9b789b6e7f6f09110a";
	      
	    meta = {
	      description = "Markdown generated from Edoc";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/uwiger/edown";
	    };
	  }
      ) {};
    
    edown = edown_0_7_0;
    
    elixir_ale_0_4_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "elixir_ale";
	    version = "0.4.1";
	    sha256 =
	      "2ee5c6989a8005a0ab8f1aea0b4f89b5feae75be78a70bade6627c3624c59c46";
	      
	    meta = {
	      description =
		"Elixir access to hardware I/O interfaces such as GPIO, I2C, and SPI.";
	      license = stdenv.lib.licenses.asl20;
	      homepage = "https://github.com/fhunleth/elixir_ale";
	    };
	  }
      ) {};
    
    elixir_ale = elixir_ale_0_4_1;
    
    eper_0_94_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "eper";
	    version = "0.94.0";
	    sha256 =
	      "8d853792fa61a7fd068fe9c113a8a44bc839e11ad70cb8d5d2884566e3bede39";
	      
	    meta = {
	      longDescription = ''Erlang Performance and Debugging Tools sherk
				- a profiler, similar to Linux oprofile or MacOs
				shark gperf - a graphical performance monitor;
				shows CPU, memory and network usage dtop -
				similar to unix top redbug- similar to the OTP
				dbg application, but safer, better etc.'';
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/massemanet/eper";
	    };
	  }
      ) {};
    
    eper = eper_0_94_0;
    
    epgsql_3_1_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "epgsql";
	    version = "3.1.1";
	    sha256 =
	      "4b3f478ad090aed7200b2a8c9f2d5ef45c3aaa167be896b5237bba4b40f461d8";
	      
	    meta = {
	      description = "PostgreSQL Client";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/epgsql/epgsql";
	    };
	  }
      ) {};
    
    epgsql = epgsql_3_1_1;
    
    episcina_1_1_0 = callPackage
      (
	{ buildHex, gproc_0_3_1 }:
	  buildHex {
	    name = "episcina";
	    version = "1.1.0";
	    sha256 =
	      "16238717bfbc8cb226342f6b098bb1fafb48c7547265a10ad3e6e83899abc46f";
	     
	    erlangDeps  = [ gproc_0_3_1 ];
	    
	    meta = {
	      description = "Erlang Connection Pool";
	      license = stdenv.lib.licenses.free; 
	    };
	  }
      ) {};
    
    episcina = episcina_1_1_0;
    
    eql_0_1_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "eql";
	    version = "0.1.2";
	    sha256 =
	      "3b1a85c491d44262802058c0de97a2c90678d5d45851b88a076b1a45a8d6d4b3";
	      
	    meta = {
	      description = "Erlang with SQL";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/artemeff/eql";
	    };
	  }
      ) {};
    
    eql = eql_0_1_2;
    
    eredis_1_0_8 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "eredis";
	    version = "1.0.8";
	    sha256 =
	      "f303533e72129b264a2d8217c4ddc977c7527ff4b8a6a55f92f62b7fcc099334";
	      
	    meta = {
	      description = "Erlang Redis client";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/wooga/eredis";
	    };
	  }
      ) {};
    
    eredis = eredis_1_0_8;
    
    erlang_term_1_4_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "erlang_term";
	    version = "1.4.0";
	    sha256 =
	      "1a4d491dbd13b7a714815af10fc658948a5a440de23755a32b741ca07d8ba592";
	      
	    meta = {
	      description = "Provide the in-memory size of Erlang terms";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/erlang_term";
	    };
	  }
      ) {};
    
    erlang_term_1_5_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "erlang_term";
	    version = "1.5.1";
	    sha256 =
	      "88bae81a80306e82fd3fc43e2d8228049e666f3cfe4627687832cd7edb878e06";
	      
	    meta = {
	      description = "Provide the in-memory size of Erlang terms";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/erlang_term";
	    };
	  }
      ) {};
    
    erlang_term = erlang_term_1_5_1;
    
    erlang_version_0_2_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "erlang_version";
	    version = "0.2.0";
	    sha256 =
	      "74daddba65a247ec57913e5de8f243af42bbbc3d6a0c411a1252da81c09ae661";
	      
	    meta = {
	      description = "Retrieve Erlang/OTP version like `18.1'";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/sapporo-beam/erlang_version";
	    };
	  }
      ) {};
    
    erlang_version = erlang_version_0_2_0;
    
    erlcloud_0_11_0 = callPackage
      (
	{ buildHex, jsx_2_6_2, lhttpc_1_3_0, meck_0_8_3 }:
	  buildHex {
	    name = "erlcloud";
	    version = "0.11.0";
	    sha256 =
	      "ca9876dab57ed8fb5fb75ab6ce11e59a346387d357d7a038a2e18d1d31a30716";
	     
	    erlangDeps  = [ jsx_2_6_2 lhttpc_1_3_0 meck_0_8_3 ];
	    
	    meta = {
	      description = "Cloud Computing library for erlang";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/gleber/erlcloud";
	    };
	  }
      ) {};
    
    erldn_1_0_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "erldn";
	    version = "1.0.2";
	    sha256 =
	      "51a721f1aac9c5fcc6abb0fa156a97ac8e033ee7cbee1624345ec6e47dfe0aa0";
	      
	    meta = {
	      description = "An edn parser for the Erlang platform.
";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/marianoguerra/erldn";
	    };
	  }
      ) {};
    
    erldn = erldn_1_0_2;
    
    erlexec_1_0_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "erlexec";
	    version = "1.0.1";
	    sha256 =
	      "eb1e11f16288db4ea35af08503eabf1250d5540c1e8bd35ba04312f5f703e14f";
	    compilePorts = true;
	     
	    meta = {
	      description = "OS Process Manager";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/saleyn/erlexec";
	    };
	  }
      ) {};
    
    erlexec = erlexec_1_0_1;
    
    erlsh_0_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "erlsh";
	    version = "0.1.0";
	    sha256 =
	      "94ef1492dd59fef211f01ffd40c47b6e51c0f59e2a3d0739366e4890961332d9";
	    compilePorts = true;
	     
	    meta = {
	      longDescription = ''Family of functions and ports involving
				interacting with the system shell, paths and
				external programs.'';
	      license = stdenv.lib.licenses.free; 
	    };
	  }
      ) {};
    
    erlsh = erlsh_0_1_0;
    
    erlsom_1_2_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "erlsom";
	    version = "1.2.1";
	    sha256 =
	      "e8f4d1d83583df7d1db8346aa30b82a6599b93fcc4b2d9165007e02ed40e7cae";
	      
	    meta = {
	      description = "erlsom XSD parser";
	      license = stdenv.lib.licenses.free; 
	    };
	  }
      ) {};
    
    erlsom = erlsom_1_2_1;
    
    erlware_commons_0_18_0 = callPackage
      (
	{ buildHex, cf_0_2_1 }:
	  buildHex {
	    name = "erlware_commons";
	    version = "0.18.0";
	    sha256 =
	      "e71dda7cd5dcf34c9d07255d49c67e1d229dd230c101fdb996820bcdb5b03c49";
	     
	    erlangDeps  = [ cf_0_2_1 ];
	    
	    meta = {
	      description = "Additional standard library for Erlang";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/erlware/erlware_commons";
	    };
	  }
      ) {};
    
    erlware_commons = erlware_commons_0_18_0;
    
    erlzk_0_6_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "erlzk";
	    version = "0.6.1";
	    sha256 =
	      "6bba045ad0b7beb566825b463ada2464929655ce01e291022c1efed81a674759";
	      
	    meta = {
	      description = "A Pure Erlang ZooKeeper Client (no C dependency)";
	      license = stdenv.lib.licenses.asl20;
	      homepage = "https://github.com/huaban/erlzk";
	    };
	  }
      ) {};
    
    erlzk = erlzk_0_6_1;
    
    esel_0_1_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "esel";
	    version = "0.1.2";
	    sha256 =
	      "874d1775c86d27d9e88486a37351ffc09f826ef062c8ea211e65d08e103f946c";
	      
	    meta = {
	      description = "An wrapper around openssl";
	      license = stdenv.lib.licenses.mit; 
	    };
	  }
      ) {};
    
    esel = esel_0_1_2;
    
    esqlite_0_2_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "esqlite";
	    version = "0.2.1";
	    sha256 =
	      "79f2d1d05e6e29e50228af794dac8900ce47dd60bc11fbf1279f924f83752689";
	    compilePorts = true;
	     
	    meta = {
	      description = "A Sqlite3 NIF";
	      license = stdenv.lib.licenses.asl20;
	      homepage = "https://github.com/mmzeeman/esqlite";
	    };
	  }
      ) {};
    
    esqlite = esqlite_0_2_1;
    
    eunit_formatters_0_3_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "eunit_formatters";
	    version = "0.3.1";
	    sha256 =
	      "64a40741429b7aff149c605d5a6135a48046af394a7282074e6003b3b56ae931";
	      
	    meta = {
	      description = "Better output for eunit suites";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/seancribbs/eunit_formatters";
	    };
	  }
      ) {};
    
    eunit_formatters = eunit_formatters_0_3_1;
    
    exec_1_0_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "exec";
	    version = "1.0.1";
	    sha256 =
	      "87c7ef2dea2bb503bb0eec8cb34776172999aecc6e12d90f7629796a7a3ccb1f";
	    compilePorts = true;
	     
	    meta = {
	      description = "OS Process Manager";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/saleyn/erlexec";
	    };
	  }
      ) {};
    
    exec = exec_1_0_1;
    
    exmerl_0_1_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "exmerl";
	    version = "0.1.1";
	    sha256 =
	      "4bb5d6c1863c5e381b460416c9b517a211db9abd9abf0f32c99b07e128b842aa";
	      
	    meta = {
	      description =
		"An Elixir wrapper for parsing XML through the xmerl_* suite of modules
";
	      license = stdenv.lib.licenses.asl20;
	      homepage = "https://github.com/pwoolcoc/exmerl";
	    };
	  }
      ) {};
    
    exmerl = exmerl_0_1_1;
    
    feeder_2_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "feeder";
	    version = "2.0.0";
	    sha256 =
	      "9780c5f032d3480cf7d9fd71d3f0c5f73211e0d3a8d9cdabcb1327b3a4ff758e";
	      
	    meta = {
	      description = "Stream parse RSS and Atom formatted XML feeds.
";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/michaelnisi/feeder";
	    };
	  }
      ) {};
    
    feeder = feeder_2_0_0;
    
    fn_1_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "fn";
	    version = "1.0.0";
	    sha256 =
	      "1433b353c8739bb28ac0d6826c9f6a05033f158e8c8195faf01a863668b3bbc7";
	      
	    meta = {
	      description = "More functional Erlang";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/artemeff/fn";
	    };
	  }
      ) {};
    
    fn = fn_1_0_0;
    
    folsom_0_8_3 = callPackage
      (
	{ buildHex, bear_0_8_3 }:
	  buildHex {
	    name = "folsom";
	    version = "0.8.3";
	    sha256 =
	      "afaa1ea4cd2a10a32242ac5d76fa7b17e98d202883859136b791d9a383b26820";
	     
	    erlangDeps  = [ bear_0_8_3 ];
	    
	    meta = {
	      description = "Erlang based metrics system";
	      license = stdenv.lib.licenses.free; 
	    };
	  }
      ) {};
    
    folsom = folsom_0_8_3;
    
    folsomite_1_2_8 = callPackage
      (
	{ buildHex, folsom_0_8_3 }:
	  buildHex {
	    name = "folsomite";
	    version = "1.2.8";
	    sha256 =
	      "9ce64603cdffb8ad55e950142146b3fe05533020906a81aa9c2f524635d813dc";
	     
	    erlangDeps  = [ folsom_0_8_3 ];
	    
	    meta = {
	      description = "Blow up your Graphite server with Folsom metrics";
	      license = stdenv.lib.licenses.free; 
	    };
	  }
      ) {};
    
    folsomite = folsomite_1_2_8;
    
    fqc_0_1_5 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "fqc";
	    version = "0.1.5";
	    sha256 =
	      "47536dec351a12e1cbe0bc3b52bfff3b0690b0aec660472b5cf49f812eb9aa4f";
	      
	    meta = {
	      description = "FiFo EQC helper";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/project-fifo/fqc";
	    };
	  }
      ) {};
    
    fs_0_9_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "fs";
	    version = "0.9.2";
	    sha256 =
	      "9a00246e8af58cdf465ae7c48fd6fd7ba2e43300413dfcc25447ecd3bf76f0c1";
	    compilePorts = true;
	     
	    meta = {
	      description = "Erlang FileSystem Listener";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/synrc/fs";
	    };
	  }
      ) {};
    
    fs = fs_0_9_2;
    
    fuse_2_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "fuse";
	    version = "2.0.0";
	    sha256 =
	      "e2c55c0629ce418974165a65b342e54527333303d7e9c1f0493679144c9698cb";
	      
	    meta = {
	      description = "A Circuit breaker implementation for Erlang";
	      license = stdenv.lib.licenses.free; 
	    };
	  }
      ) {};
    
    fuse = fuse_2_0_0;
    
    gen_listener_tcp_0_3_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "gen_listener_tcp";
	    version = "0.3.2";
	    sha256 =
	      "b3c3fbc525ba2b32d947b06811d38470d5b0abe2ca81b623192a71539ed22336";
	      
	    meta = {
	      description = "Generic TCP Server";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/travelping/gen_listener_tcp";
	    };
	  }
      ) {};
    
    gen_listener_tcp = gen_listener_tcp_0_3_2;
    
    gen_smtp_0_9_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "gen_smtp";
	    version = "0.9.0";
	    sha256 =
	      "5a05f23a7cbe0c6242d290b445c6bbc0c287e3d0e09d3fcdc6bcd2c8973b6688";
	      
	    meta = {
	      longDescription = ''A generic Erlang SMTP server framework that
				can be extended via callback modules in the OTP
				style. '';
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/Vagabond/gen_smtp";
	    };
	  }
      ) {};
    
    gen_smtp = gen_smtp_0_9_0;
    
    getopt_0_8_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "getopt";
	    version = "0.8.2";
	    sha256 =
	      "736e6db3679fbbad46373efb96b69509f8e420281635e9d92989af9f0a0483f7";
	      
	    meta = {
	      description = "Command-line options parser for Erlang";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/jcomellas/getopt";
	    };
	  }
      ) {};
    
    getopt = getopt_0_8_2;
    
    goldrush_0_1_7 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "goldrush";
	    version = "0.1.7";
	    sha256 =
	      "a94a74cd363ce5f4970ed8242c551ec62b71939db1bbfd2e030142cab25a4ffe";
	      
	    meta = {
	      description =
		"Small, Fast event processing and monitoring for Erlang/OTP applications.
";
	      license = stdenv.lib.licenses.isc;
	      homepage = "https://github.com/DeadZen/goldrush";
	    };
	  }
      ) {};
    
    goldrush = goldrush_0_1_7;
    
    gproc_0_3_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "gproc";
	    version = "0.3.1";
	    sha256 =
	      "3c449925a5cbf57cc40d13c6c282bc1080b5ed3bad97e1acdbe969fd63a65fce";
	      
	    meta = {
	      longDescription = ''Gproc is a process dictionary for Erlang,
				which provides a number of useful features
				beyond what the built-in dictionary has: * Use
				any term as a process alias * Register a process
				under several aliases * Non-unique properties
				can be registered simultaneously by many
				processes * QLC and match specification
				interface for efficient queries on the
				dictionary * Await registration, let's you wait
				until a process registers itself * Atomically
				give away registered names and properties to
				another process * Counters, and aggregated
				counters, which automatically maintain the total
				of all counters with a given name * Global
				registry, with all the above functions applied
				to a network of nodes'';
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/uwiger/gproc";
	    };
	  }
      ) {};
    
    gproc_0_5_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "gproc";
	    version = "0.5.0";
	    sha256 =
	      "5bc0fa4e999a6665b92ce57a7f12d7e9d1c26bfc39b0f657994be05cd3818b18";
	      
	    meta = {
	      longDescription = ''Gproc is a process dictionary for Erlang,
				which provides a number of useful features
				beyond what the built-in dictionary has: * Use
				any term as a process alias * Register a process
				under several aliases * Non-unique properties
				can be registered simultaneously by many
				processes * QLC and match specification
				interface for efficient queries on the
				dictionary * Await registration, let's you wait
				until a process registers itself * Atomically
				give away registered names and properties to
				another process * Counters, and aggregated
				counters, which automatically maintain the total
				of all counters with a given name * Global
				registry, with all the above functions applied
				to a network of nodes'';
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/uwiger/gproc";
	    };
	  }
      ) {};
    
    gproc = gproc_0_5_0;
    
    gurka_0_1_7 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "gurka";
	    version = "0.1.7";
	    sha256 =
	      "b46c96446f46a53411a3b45d126ec19e724178818206ca1d2dd16abff28df6b5";
	      
	    meta = {
	      description = "Erlang implementation of Cucumber";
	      license = stdenv.lib.licenses.mit; 
	    };
	  }
      ) {};
    
    gurka = gurka_0_1_7;
    
    hamcrest_0_1_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "hamcrest";
	    version = "0.1.1";
	    sha256 =
	      "5207b83e8d3168b9cbbeb3b4c4d83817a38a05f55478510e9c4db83ef83fa0ca";
	      
	    meta = {
	      description = "Erlang port of Hamcrest";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/hyperthunk/hamcrest-erlang";
	    };
	  }
      ) {};
    
    hamcrest = hamcrest_0_1_1;
    
    hlc_2_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "hlc";
	    version = "2.0.0";
	    sha256 =
	      "460ac04654e920e068d1fd17aec1f78b1879cc42ac7f3def7497f0d1cc5056ad";
	      
	    meta = {
	      description = "hybrid logical clock";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/barrel-db/hlc";
	    };
	  }
      ) {};
    
    hlc = hlc_2_0_0;
    
    hooks_1_1_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "hooks";
	    version = "1.1.1";
	    sha256 =
	      "6834ad3a2a624a5ffd49e9cb146ff49ded423b67f31905b122d24128c72c5c85";
	      
	    meta = {
	      description = "generic plugin & hook system";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/barrel-db/hooks";
	    };
	  }
      ) {};
    
    hooks = hooks_1_1_1;
    
    http_signature_1_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "http_signature";
	    version = "1.1.0";
	    sha256 =
	      "3e6036d9c29289ed0e35dd6f41821dec9061ce20aad3c4d35dcbae8c84eb3baa";
	      
	    meta = {
	      description =
		"Erlang and Elixir implementations of Joyent's HTTP Signature Scheme.";
	      license = stdenv.lib.licenses.free;
	      homepage =
		"https://github.com/potatosalad/erlang-http_signature";
	    };
	  }
      ) {};
    
    http_signature = http_signature_1_1_0;
    
    ibrowse_4_2_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "ibrowse";
	    version = "4.2.2";
	    sha256 =
	      "b800cb7442bcc852c6832821e9d0a7098ff626e1415bddaeff4596640b31c0ae";
	      
	    meta = {
	      description = "Erlang HTTP client application";
	      license = with stdenv.lib.licenses; [ free bsd3 ];
	      homepage = "https://github.com/cmullaparthi/ibrowse";
	    };
	  }
      ) {};
    
    ibrowse = ibrowse_4_2_2;
    
    idna_1_0_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "idna";
	    version = "1.0.2";
	    sha256 =
	      "a5d645e307aa4f67efe31682f720b7eaf431ab148b3d6fb66cbaf6314499610f";
	      
	    meta = {
	      description = "A pure Erlang IDNA implementation";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/benoitc/erlang-idna";
	    };
	  }
      ) {};
    
    idna_1_0_3 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "idna";
	    version = "1.0.3";
	    sha256 =
	      "357d489a51112db4f216034406834f9172b3c0ff5a12f83fb28b25ca271541d1";
	      
	    meta = {
	      description = "A pure Erlang IDNA implementation";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/benoitc/erlang-idna";
	    };
	  }
      ) {};
    
    idna = idna_1_0_3;
    
    inaka_aleppo_0_9_6 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "inaka_aleppo";
	    version = "0.9.6";
	    sha256 =
	      "774171dc84a300f63a15fe732773edf535d7414286890e961e754f1f794dbc85";
	      
	    meta = {
	      description = "Aleppo: ALternative Erlang Pre-ProcessOr";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/inaka/aleppo";
	    };
	  }
      ) {};
    
    inaka_aleppo = inaka_aleppo_0_9_6;
    
    inaka_mixer_0_1_5 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "inaka_mixer";
	    version = "0.1.5";
	    sha256 =
	      "37af35b1c17a94a0cb643cba23cba2ca68d6fe51c3ad8337629d4c3c017cc912";
	      
	    meta = {
	      description = "Mix in public functions from external modules";
	      license = stdenv.lib.licenses.asl20;
	      homepage = "https://github.com/inaka/mixer";
	    };
	  }
      ) {};
    
    inaka_mixer = inaka_mixer_0_1_5;
    
    jiffy_0_14_7 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "jiffy";
	    version = "0.14.7";
	    sha256 =
	      "2b3b0f7976dae9c8266036e0d7e0398b64ac5207e3beee4c57896e44b2c17e97";
	    compilePorts = true;
	     
	    meta = {
	      description = "JSON Decoder/Encoder";
	      license = with stdenv.lib.licenses; [ mit bsd3 ];
	      homepage = "https://github.com/davisp/jiffy";
	    };
	  }
      ) {};
    
    jiffy = jiffy_0_14_7;
    
    jsone_1_2_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "jsone";
	    version = "1.2.0";
	    sha256 =
	      "a60e74284d3a923cde65c00a39dd4542fd7da7c22e8385c0378ad419c54b2e08";
	      
	    meta = {
	      description = "Erlang JSON Library";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/sile/jsone";
	    };
	  }
      ) {};
    
    jsone = jsone_1_2_0;
    
    jsx_1_4_5 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "jsx";
	    version = "1.4.5";
	    sha256 =
	      "ff5115611c5dd789cebe3addc07d18b86340f701c52ad063caba6fe8da3a489b";
	      
	    meta = {
	      longDescription = ''an erlang application for consuming,
				producing and manipulating json. inspired by
				yajl'';
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/talentdeficit/jsx";
	    };
	  }
      ) {};
    
    jsx_2_2_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "jsx";
	    version = "2.2.0";
	    sha256 =
	      "d0bbc1ef47fd2fed84e28faed66918cf9eceed03b7ded48a23076e716fdbc84f";
	      
	    meta = {
	      longDescription = ''an erlang application for consuming,
				producing and manipulating json. inspired by
				yajl'';
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/talentdeficit/jsx";
	    };
	  }
      ) {};
    
    jsx_2_6_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "jsx";
	    version = "2.6.2";
	    sha256 =
	      "6bfccb6461cc3c7d5cc63f3e69ffeb2f1f8de50eca5980065311c056a69a907f";
	      
	    meta = {
	      longDescription = ''an erlang application for consuming,
				producing and manipulating json. inspired by
				yajl'';
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/talentdeficit/jsx";
	    };
	  }
      ) {};
    
    jsx_2_7_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "jsx";
	    version = "2.7.1";
	    sha256 =
	      "52d0e8bda0c8624bc59c3119236eb49bb66289702ea3d59ad76fd2a56cdf9089";
	      
	    meta = {
	      longDescription = ''an erlang application for consuming,
				producing and manipulating json. inspired by
				yajl'';
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/talentdeficit/jsx";
	    };
	  }
      ) {};
    
    jsx_2_8_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "jsx";
	    version = "2.8.0";
	    sha256 =
	      "a8ba15d5bac2c48b2be1224a0542ad794538d79e2cc16841a4e24ca75f0f8378";
	      
	    meta = {
	      longDescription = ''an erlang application for consuming,
				producing and manipulating json. inspired by
				yajl'';
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/talentdeficit/jsx";
	    };
	  }
      ) {};
    
    jsx = jsx_2_8_0;
    
    jsxd_0_1_10 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "jsxd";
	    version = "0.1.10";
	    sha256 =
	      "f71a8238f08a1dee130e8959ff5343524891fa6531392667a5b911cead5f5082";
	      
	    meta = {
	      description =
		"jsx data structire traversing and modification library.";
	      license = stdenv.lib.licenses.cddl;
	      homepage = "https://github.com/Licenser/jsxd";
	    };
	  }
      ) {};
    
    jsxd = jsxd_0_1_10;
    
    jwalk_1_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "jwalk";
	    version = "1.1.0";
	    sha256 =
	      "10c150910ba3539583887cb2b5c3f70d602138471e6f6b5c22498aa18ed654e1";
	      
	    meta = {
	      longDescription = ''Helper module for working with Erlang
				proplist, map, EEP-18 and mochijson-style
				representations of JSON'';
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/jr0senblum/jwalk";
	    };
	  }
      ) {};
    
    jwalk = jwalk_1_1_0;
    
    jwt_0_1_1 = callPackage
      (
	{ buildHex, base64url_0_0_1, jsx_2_8_0 }:
	  buildHex {
	    name = "jwt";
	    version = "0.1.1";
	    sha256 =
	      "abcff4a2a42af2b7b7bdf55eeb2b73ce2e3bef760750004e74bc5835d64d2188";
	     
	    erlangDeps  = [ base64url_0_0_1 jsx_2_8_0 ];
	    
	    meta = {
	      description = "Erlang JWT library";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/artemeff/jwt";
	    };
	  }
      ) {};
    
    jwt = jwt_0_1_1;
    
    key2value_1_4_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "key2value";
	    version = "1.4.0";
	    sha256 =
	      "ad63453fcf54ab853581b78c6d2df56be41ea691ba4bc05920264c19f35a0ded";
	      
	    meta = {
	      description = "Erlang 2-way Map";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/key2value";
	    };
	  }
      ) {};
    
    key2value_1_5_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "key2value";
	    version = "1.5.1";
	    sha256 =
	      "2a40464b9f8ef62e8828d869ac8d2bf9135b4956d29ba4eb044e8522b2d35ffa";
	      
	    meta = {
	      description = "Erlang 2-way Map";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/key2value";
	    };
	  }
      ) {};
    
    key2value = key2value_1_5_1;
    
    keys1value_1_5_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "keys1value";
	    version = "1.5.1";
	    sha256 =
	      "2385132be0903c170fe21e54a0c3e746a604777b66ee458bb6e5f25650d3354f";
	      
	    meta = {
	      description = "Erlang Set Associative Map For Key Lists";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/keys1value";
	    };
	  }
      ) {};
    
    keys1value = keys1value_1_5_1;
    
    lager_3_0_1 = callPackage
      (
	{ buildHex, goldrush_0_1_7 }:
	  buildHex {
	    name = "lager";
	    version = "3.0.1";
	    sha256 =
	      "d32c9233105b72dc5c1f6a8fe9a33cc205ecccc359c4449950060cee5a329e35";
	     
	    erlangDeps  = [ goldrush_0_1_7 ];
	    
	    meta = {
	      description = "Erlang logging framework";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/basho/lager";
	    };
	  }
      ) {};
    
    lager_3_0_2 = callPackage
      (
	{ buildHex, goldrush_0_1_7 }:
	  buildHex {
	    name = "lager";
	    version = "3.0.2";
	    sha256 =
	      "527f3b233e01b6cb68780c14ef675ed08ec02247dc029cacecbb56c78dfca100";
	     
	    erlangDeps  = [ goldrush_0_1_7 ];
	    
	    meta = {
	      description = "Erlang logging framework";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/basho/lager";
	    };
	  }
      ) {};
    
    lager = lager_3_0_2;
    
    lasse_1_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "lasse";
	    version = "1.1.0";
	    sha256 =
	      "53e70ea9031f7583331a9f9bdbb29da933e591e5c4cce521b4bf85c68e7f3385";
	      
	    meta = {
	      description = "Lasse: Server-Sent Event handler for Cowboy";
	      license = stdenv.lib.licenses.asl20;
	      homepage = "https://github.com/inaka/lasse";
	    };
	  }
      ) {};
    
    lasse = lasse_1_1_0;
    
    lhttpc_1_3_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "lhttpc";
	    version = "1.3.0";
	    sha256 =
	      "ddd2bd4b85159bc987c954b14877168e6a3c3e516105702189776e97c50296a4";
	      
	    meta = {
	      description = "Lightweight HTTP/1.1 client";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/talko/lhttpc";
	    };
	  }
      ) {};
    
    lhttpc = lhttpc_1_3_0;
    
    libsnarlmatch_0_1_5 = callPackage
      (
	{ buildHex, fqc_0_1_5 }:
	  buildHex {
	    name = "libsnarlmatch";
	    version = "0.1.5";
	    sha256 =
	      "11410122ca7a0685c4a7df1795d7f5a1e7bf9c5f17096414402fd9d1f0e1ac04";
	     
	    erlangDeps  = [ fqc_0_1_5 ];
	    
	    meta = {
	      description = "permission matcher library";
	      license = stdenv.lib.licenses.cddl;
	      homepage = "https://github.com/project-fifo/libsnarlmatch";
	    };
	  }
      ) {};
    
    libsnarlmatch_0_1_7 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "libsnarlmatch";
	    version = "0.1.7";
	    sha256 =
	      "72e9bcf7968e75774393778146ac6596116f1c60136dd607ad249183684ee380";
	      
	    meta = {
	      description = "permission matcher library";
	      license = stdenv.lib.licenses.cddl;
	      homepage = "https://github.com/project-fifo/libsnarlmatch";
	    };
	  }
      ) {};
    
    libsnarlmatch = libsnarlmatch_0_1_7;
    
    lru_1_3_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "lru";
	    version = "1.3.1";
	    sha256 =
	      "cd6ac15c383d58cd2933df9cb918617b24b12b6e5fb24d94c4c8f200fd93f619";
	      
	    meta = {
	      description = "implements a fixed-size LRU cache";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/barrel-db/erlang-lru";
	    };
	  }
      ) {};
    
    lru = lru_1_3_1;
    
    lz4_0_2_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "lz4";
	    version = "0.2.2";
	    sha256 =
	      "a59522221e7cdfe3792bf8b3bb21cfe7ac657790e5826201fa2c5d0bc7484a2d";
	    compilePorts = true;
	     
	    meta = {
	      description = "LZ4 bindings for Erlang";
	      license = stdenv.lib.licenses.isc;
	      homepage = "https://github.com/szktty/erlang-lz4.git";
	    };
	  }
      ) {};
    
    lz4 = lz4_0_2_2;
    
    mdns_server_0_2_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "mdns_server";
	    version = "0.2.0";
	    sha256 =
	      "bc9465880e15e57033960ab6820258b87134bef69032210c67e53e3718e289d0";
	      
	    meta = {
	      description = "mDNS service discovery server";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/Licenser/erlang-mdns-server";
	    };
	  }
      ) {};
    
    mdns_server = mdns_server_0_2_0;
    
    mdns_server_lib_0_2_3 = callPackage
      (
	{ buildHex, lager_3_0_2, mdns_server_0_2_0, ranch_1_1_0 }:
	  buildHex {
	    name = "mdns_server_lib";
	    version = "0.2.3";
	    sha256 =
	      "078775ccea5d768095716ca6bd82f657601203352495d9726f4cc080c8c07695";
	     
	    erlangDeps  = [ lager_3_0_2 mdns_server_0_2_0 ranch_1_1_0 ];
	    
	    meta = {
	      description =
		"server side for mdns client server implementation";
	      license = stdenv.lib.licenses.cddl;
	      homepage = "https://github.com/Licenser/mdns_server_lib";
	    };
	  }
      ) {};
    
    mdns_server_lib = mdns_server_lib_0_2_3;
    
    meck_0_8_3 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "meck";
	    version = "0.8.3";
	    sha256 =
	      "53bd3873d0193d6b2b4a165cfc4b9ffc3934355c3ba19e88239ef6a027cc02b6";
	      
	    meta = {
	      description = "A mocking framework for Erlang";
	      license = stdenv.lib.licenses.asl20;
	      homepage = "https://github.com/eproxus/meck";
	    };
	  }
      ) {};
    
    meck_0_8_4 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "meck";
	    version = "0.8.4";
	    sha256 =
	      "2cdfbd0edd8f62b3d2061efc03c0e490282dd2ea6de44e15d2006e83f4f8eead";
	      
	    meta = {
	      description = "A mocking framework for Erlang";
	      license = stdenv.lib.licenses.asl20;
	      homepage = "https://github.com/eproxus/meck";
	    };
	  }
      ) {};
    
    meck = meck_0_8_4;
    
    metrics_0_2_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "metrics";
	    version = "0.2.1";
	    sha256 =
	      "1cccc3534fa5a7861a3dcc0414afba00a616937e82c95d6172a523a5d2e97c03";
	      
	    meta = {
	      description =
		"A generic interface to different metrics systems in Erlang.";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/benoitc/erlang-metrics";
	    };
	  }
      ) {};
    
    metrics = metrics_0_2_1;
    
    mimerl_1_0_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "mimerl";
	    version = "1.0.2";
	    sha256 =
	      "7a4c8e1115a2732a67d7624e28cf6c9f30c66711a9e92928e745c255887ba465";
	      
	    meta = {
	      description = "Library to handle mimetypes";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/benoitc/mimerl";
	    };
	  }
      ) {};
    
    mimerl_1_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "mimerl";
	    version = "1.1.0";
	    sha256 =
	      "def0f1922a5dcdeeee6e4f41139b364e7f0f40239774b528a0986b12bcb42ddc";
	      
	    meta = {
	      description = "Library to handle mimetypes";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/benoitc/mimerl";
	    };
	  }
      ) {};
    
    mimerl = mimerl_1_1_0;
    
    mochiweb_2_12_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "mochiweb";
	    version = "2.12.2";
	    sha256 =
	      "d3e681d4054b74a96cf2efcd09e94157ab83a5f55ddc4ce69f90b8144673bd7a";
	      
	    meta = {
	      description =
		"MochiWeb is an Erlang library for building lightweight HTTP servers.
";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/mochi/mochiweb";
	    };
	  }
      ) {};
    
    mochiweb = mochiweb_2_12_2;
    
    mtx_1_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "mtx";
	    version = "1.0.0";
	    sha256 =
	      "3bdcb209fe3cdfc5a6b5b95f619ecd123b7ee1d9203ace2178c8ff73be5bb90f";
	      
	    meta = {
	      description = "Metrics Client";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/synrc/mtx";
	    };
	  }
      ) {};
    
    mtx = mtx_1_0_0;
    
    pc_1_2_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "pc";
	    version = "1.2.0";
	    sha256 =
	      "ef0f59d26a25af0a5247ef1a06d28d8300f8624647b02dc521ac79a7eceb8883";
	      
	    meta = {
	      description = "a rebar3 port compiler for native code";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/blt/port_compiler";
	    };
	  }
      ) {};
    
    pc = pc_1_2_0;
    
    poolboy_1_5_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "poolboy";
	    version = "1.5.1";
	    sha256 =
	      "8f7168911120e13419e086e78d20e4d1a6776f1eee2411ac9f790af10813389f";
	      
	    meta = {
	      description = "A hunky Erlang worker pool factory";
	      license = with stdenv.lib.licenses; [ unlicense asl20 ];
	      homepage = "https://github.com/devinus/poolboy";
	    };
	  }
      ) {};
    
    poolboy = poolboy_1_5_1;
    
    pooler_1_5_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "pooler";
	    version = "1.5.0";
	    sha256 =
	      "f493b4b947967fa4250dd1f96e86a5440ecab51da114d2c256cced58ad991908";
	      
	    meta = {
	      description = "An OTP Process Pool Application";
	      license = stdenv.lib.licenses.asl20;
	      homepage = "https://github.com/seth/pooler";
	    };
	  }
      ) {};
    
    pooler = pooler_1_5_0;
    
    pot_0_9_3 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "pot";
	    version = "0.9.3";
	    sha256 =
	      "752d2605c15605cd455cb3514b1ce329309eb61dfa88397dce49772dac9ad581";
	      
	    meta = {
	      description = "One Time Passwords for Erlang";
	      license = stdenv.lib.licenses.free; 
	    };
	  }
      ) {};
    
    pot = pot_0_9_3;
    
    pqueue_1_5_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "pqueue";
	    version = "1.5.1";
	    sha256 =
	      "7ba01afe6b50ea4b239fa770f9e2c2db4871b3927ac44aea180d1fd52601b317";
	      
	    meta = {
	      description = "Erlang Priority Queue Implementation";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/pqueue";
	    };
	  }
      ) {};
    
    pqueue = pqueue_1_5_1;
    
    proper_1_1_1_beta = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "proper";
	    version = "1.1.1-beta";
	    sha256 =
	      "bde5c0fef0f8d804a7c06aab4f293d19f42149e5880b3412b75efa608e86d342";
	      
	    meta = {
	      description =
		"QuickCheck-inspired property-based testing tool for Erlang.";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/manopapad/proper";
	    };
	  }
      ) {};
    
    proper = proper_1_1_1_beta;
    
    providers_1_6_0 = callPackage
      (
	{ buildHex, getopt_0_8_2 }:
	  buildHex {
	    name = "providers";
	    version = "1.6.0";
	    sha256 =
	      "0f6876529a613d34224de8c61d3660388eb981142360f2699486d8536050ce2f";
	     
	    erlangDeps  = [ getopt_0_8_2 ];
	    
	    meta = {
	      description = "Providers provider";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/tsloughter/providers";
	    };
	  }
      ) {};
    
    providers = providers_1_6_0;
    
    quickrand_1_5_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "quickrand";
	    version = "1.5.1";
	    sha256 =
	      "0b3dcc6ddb23319c1f6a5ed143778864b8ad2f0ebd693a2d121cf5ae0c4db507";
	      
	    meta = {
	      longDescription = ''Quick Random Number Generation: Provides a
				simple interface to call efficient random number
				generation functions based on the context.
				Proper random number seeding is enforced.'';
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/quickrand";
	    };
	  }
      ) {};
    
    quickrand = quickrand_1_5_1;
    
    quintana_0_2_0 = callPackage
      (
	{ buildHex, folsom_0_8_3 }:
	  buildHex {
	    name = "quintana";
	    version = "0.2.0";
	    sha256 =
	      "0646fe332ca3415ca6b0b273b4a5689ec902b9f9004ca62229ded00bd5f64cda";
	     
	    erlangDeps  = [ folsom_0_8_3 ];
	    
	    meta = {
	      description = "Wrapper around some Folsom functions";
	      license = stdenv.lib.licenses.free; 
	    };
	  }
      ) {};
    
    quintana_0_2_1 = callPackage
      (
	{ buildHex, folsom_0_8_3 }:
	  buildHex {
	    name = "quintana";
	    version = "0.2.1";
	    sha256 =
	      "d4683eb33c71f6cab3b17b896b4fa9180f17a0a8b086440bfe0c5675182f0194";
	     
	    erlangDeps  = [ folsom_0_8_3 ];
	    
	    meta = {
	      description = "Wrapper around some Folsom functions";
	      license = stdenv.lib.licenses.free; 
	    };
	  }
      ) {};
    
    quintana = quintana_0_2_1;
    
    rabbit_common_3_5_6 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "rabbit_common";
	    version = "3.5.6";
	    sha256 =
	      "9335ab3ebc4e8e140d7bc9b1b0e7ee99c0aa87d0a746b704184121ba35c04f1c";
	      
	    meta = {
	      longDescription = ''Includes modules which are a runtime
				dependency of the RabbitMQ/AMQP Erlang client
				and are common to the RabbitMQ server.'';
	      license = stdenv.lib.licenses.mpl11;
	      homepage = "https://github.com/jbrisbin/rabbit_common";
	    };
	  }
      ) {};
    
    rabbit_common = rabbit_common_3_5_6;
    
    ranch_1_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "ranch";
	    version = "1.1.0";
	    sha256 =
	      "98ade939e63e6567da5dec5bc5bd93cbdc53d53f8b1aa998adec60dc4057f048";
	      
	    meta = {
	      description = "Socket acceptor pool for TCP protocols";
	      license = stdenv.lib.licenses.isc;
	      homepage = "https://github.com/ninenines/ranch";
	    };
	  }
      ) {};
    
    ranch_1_2_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "ranch";
	    version = "1.2.0";
	    sha256 =
	      "82bbb48cdad151000f7ad600d7a29afd972df409fde600bbc9b1ed4fdc08c399";
	      
	    meta = {
	      description = "Socket acceptor pool for TCP protocols";
	      license = stdenv.lib.licenses.isc;
	      homepage = "https://github.com/ninenines/ranch";
	    };
	  }
      ) {};
    
    ranch = ranch_1_2_0;
    
    ratx_0_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "ratx";
	    version = "0.1.0";
	    sha256 =
	      "fbf933ff32fdc127200880f5b567820bf03504ade1bd697ffbc0535dbafc23d6";
	      
	    meta = {
	      description =
		"Rate limiter and overload protection for erlang and elixir applications.
";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/liveforeverx/ratx";
	    };
	  }
      ) {};
    
    ratx = ratx_0_1_0;
    
    rebar3_asn1_compiler_1_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "rebar3_asn1_compiler";
	    version = "1.0.0";
	    sha256 =
	      "25ec1d5c97393195650ac8c7a06a267a886a1479950ee047c43b5228c07b30b9";
	      
	    meta = {
	      description = "Compile ASN.1 modules with Rebar3";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/pyykkis/rebar3_asn1_compiler";
	    };
	  }
      ) {};
    
    rebar3_asn1_compiler = rebar3_asn1_compiler_1_0_0;
    
    rebar3_diameter_compiler_0_3_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "rebar3_diameter_compiler";
	    version = "0.3.1";
	    sha256 =
	      "c5965e3810ccf9ef9ba9185a81fe569ef6e9f3a9e546e99c5e900736b0c39274";
	      
	    meta = {
	      description = "Compile diameter .dia files";
	      license = stdenv.lib.licenses.mit;
	      homepage =
		"https://github.com/carlosedp/rebar3_diameter_compiler";
	    };
	  }
      ) {};
    
    rebar3_diameter_compiler = rebar3_diameter_compiler_0_3_1;
    
    rebar3_hex_1_14_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "rebar3_hex";
	    version = "1.14.0";
	    sha256 =
	      "e655ba352835654d41b8077695415792a0de01f3200aa1ce0c8458f785ec2311";
	      
	    meta = {
	      description = "Hex.pm plugin for rebar3";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/tsloughter/rebar3_hex";
	    };
	  }
      ) {};
    
    rebar3_hex = rebar3_hex_1_14_0;
    
    rebar3_idl_compiler_0_3_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "rebar3_idl_compiler";
	    version = "0.3.0";
	    sha256 =
	      "31ba95205c40b990cb3c49abb397abc47b4d5f9c402db83f9daebbc44e69789d";
	      
	    meta = {
	      description = "Rebar3 IDL Compiler";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/sebastiw/rebar3_idl_compiler";
	    };
	  }
      ) {};
    
    rebar3_idl_compiler = rebar3_idl_compiler_0_3_0;
    
    rebar_alias_0_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "rebar_alias";
	    version = "0.1.0";
	    sha256 =
	      "59fb42b39964af3a29ebe94c11247f618dd4d5e4e1a69cfaffabbed03ccff70f";
	      
	    meta = {
	      description = "A rebar plugin";
	      license = stdenv.lib.licenses.free; 
	    };
	  }
      ) {};
    
    rebar_alias = rebar_alias_0_1_0;
    
    rebar_erl_vsn_0_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "rebar_erl_vsn";
	    version = "0.1.0";
	    sha256 =
	      "7cf1e2e85a80785a4e4e1529a2c837dbd2d540214cf791214e56f931e5e9865d";
	      
	    meta = {
	      description = "defines for erlang versions";
	      license = stdenv.lib.licenses.mit; 
	    };
	  }
      ) {};
    
    rebar_erl_vsn = rebar_erl_vsn_0_1_0;
    
    recon_2_2_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "recon";
	    version = "2.2.1";
	    sha256 =
	      "6c548ad0f4916495a78977674a251847869f85b5125b7c2a44da3178955adfd1";
	      
	    meta = {
	      longDescription = ''Recon wants to be a set of tools usable in
				production to diagnose Erlang problems or
				inspect production environment safely.'';
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/ferd/recon";
	    };
	  }
      ) {};
    
    recon = recon_2_2_1;
    
    redo_2_0_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "redo";
	    version = "2.0.1";
	    sha256 =
	      "f7b2be8c825ec34413c54d8f302cc935ce4ecac8421ae3914c5dadd816dcb1e6";
	      
	    meta = {
	      description = "Pipelined Redis Erlang Driver";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/heroku/redo";
	    };
	  }
      ) {};
    
    redo = redo_2_0_1;
    
    reltool_util_1_4_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "reltool_util";
	    version = "1.4.0";
	    sha256 =
	      "a625874976fffe8ab56d4b5b7d5fd37620a2692462bbe24ae003ab13052ef0d3";
	      
	    meta = {
	      description = "Erlang reltool utility functionality application";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/reltool_util";
	    };
	  }
      ) {};
    
    reltool_util_1_5_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "reltool_util";
	    version = "1.5.1";
	    sha256 =
	      "746e16871afdcf85d8a115389193c8d660d0df1d26d6ac700590e0ad252646b1";
	      
	    meta = {
	      description = "Erlang reltool utility functionality application";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/reltool_util";
	    };
	  }
      ) {};
    
    reltool_util = reltool_util_1_5_1;
    
    relx_3_13_0 = callPackage
      (
	{
	  buildHex,
	  bbmustache_1_0_4,
	  cf_0_2_1,
	  erlware_commons_0_18_0,
	  getopt_0_8_2,
	  providers_1_6_0
	}:
	  buildHex {
	    name = "relx";
	    version = "3.13.0";
	    sha256 =
	      "1ccadc6c9c6883807be0a6250411d2c299c532928e0a6d07db812400a2303ec1";
	     
	    erlangDeps  = [
			    bbmustache_1_0_4
			    cf_0_2_1
			    erlware_commons_0_18_0
			    getopt_0_8_2
			    providers_1_6_0
			  ];
	    
	    meta = {
	      description = "Release assembler for Erlang/OTP Releases";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/erlware/relx";
	    };
	  }
      ) {};
    
    relx = relx_3_13_0;
    
    savory_0_0_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "savory";
	    version = "0.0.2";
	    sha256 =
	      "a45ef32a6f45092e1328bc1eb47bda3c8f992afe863aaa73c455f31b0c8591b9";
	      
	    meta = {
	      longDescription = ''An Elixir implementation of Freza's salt_nif
				which interfaces with libsodium, a wrapper for
				the cryptographic primitive libary NaCl. '';
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/electricFeel/savory";
	    };
	  }
      ) {};
    
    savory = savory_0_0_2;
    
    sbroker_0_7_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "sbroker";
	    version = "0.7.0";
	    sha256 =
	      "5bc0bfd79896fd5b92072a71fa4a1e120f4110f2cf9562a0b9dd2fcfe9e5cfd2";
	      
	    meta = {
	      description =
		"Process broker for dispatching with backpressure and load shedding";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/fishcakez/sbroker";
	    };
	  }
      ) {};
    
    sbroker = sbroker_0_7_0;
    
    serial_0_1_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "serial";
	    version = "0.1.2";
	    sha256 =
	      "c0aed287f565b7ce1e1091a6a3dd08fd99bf0884c81b53ecf978c502ef652231";
	      
	    meta = {
	      description = "Serial communication through Elixir ports";
	      license = stdenv.lib.licenses.isc;
	      homepage = "https://github.com/bitgamma/elixir_serial";
	    };
	  }
      ) {};
    
    serial = serial_0_1_2;
    
    sidejob_2_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "sidejob";
	    version = "2.0.0";
	    sha256 =
	      "19fea24060a1d0d37e78480fbd79d6b95e07f445aad725f7124a23194641c743";
	      
	    meta = {
	      longDescription = ''sidejob is an Erlang library that implements
				a parallel, capacity-limited request pool. In
				sidejob, these pools are called resources. A
				resource is managed by multiple gen_server like
				processes which can be sent calls and casts
				using sidejob:call or sidejob:cast respectively.
				This library was originally written to support
				process bounding in Riak using the
				sidejob_supervisor behavior. In Riak, this is
				used to limit the number of concurrent get/put
				FSMs that can be active, failing client requests
				with {error, overload} if the limit is ever hit.
				The purpose being to provide a fail-safe
				mechanism during extreme overload scenarios. '';
	      license = stdenv.lib.licenses.asl20;
	      homepage = "https://github.com/basho/sidejob";
	    };
	  }
      ) {};
    
    sidejob = sidejob_2_0_0;
    
    slp_0_0_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "slp";
	    version = "0.0.2";
	    sha256 =
	      "27e5f7330c7ce631f16e3ec5781b31cbb2247d2bcdeab1e979a66dcc4397bd77";
	      
	    meta = {
	      longDescription = ''An Elixir application for using the Service
				Location Protocol. SLP is a commonly used
				service discovery protocol.'';
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/stuart/elixir_slp";
	    };
	  }
      ) {};
    
    slp = slp_0_0_2;
    
    smurf_0_1_3 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "smurf";
	    version = "0.1.3";
	    sha256 =
	      "5ed8e18ec8eea0647e7e938ce15cc76e59497d0a259cea15124520a48f0d6be6";
	      
	    meta = {
	      description = "SMF interfacing library for erlang";
	      license = stdenv.lib.licenses.cddl;
	      homepage = "https://github.com/project-fifo/smurf";
	    };
	  }
      ) {};
    
    smurf = smurf_0_1_3;
    
    ssl_verify_hostname_1_0_5 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "ssl_verify_hostname";
	    version = "1.0.5";
	    sha256 =
	      "f2cb11e6144e10ab39d1e14bf9fb2437b690979c70bf5428e9dc4bfaf1dfeabf";
	      
	    meta = {
	      description = "Hostname verification library for Erlang";
	      license = stdenv.lib.licenses.mit;
	      homepage =
		"https://github.com/deadtrickster/ssl_verify_hostname.erl";
	    };
	  }
      ) {};
    
    ssl_verify_hostname_1_0_6 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "ssl_verify_hostname";
	    version = "1.0.6";
	    sha256 =
	      "72b2fc8a8e23d77eed4441137fefa491bbf4a6dc52e9c0045f3f8e92e66243b5";
	      
	    meta = {
	      description = "Hostname verification library for Erlang";
	      license = stdenv.lib.licenses.mit;
	      homepage =
		"https://github.com/deadtrickster/ssl_verify_hostname.erl";
	    };
	  }
      ) {};
    
    ssl_verify_hostname = ssl_verify_hostname_1_0_6;
    
    strftimerl_0_1_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "strftimerl";
	    version = "0.1.1";
	    sha256 =
	      "c09c7cd6a421bcbc1020c1440a2e73e312b852adbb3034d11f3dffa27d7953b1";
	      
	    meta = {
	      description = "strftime formatting in erlang";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/gmr/strftimerl";
	    };
	  }
      ) {};
    
    strftimerl = strftimerl_0_1_1;
    
    supool_1_5_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "supool";
	    version = "1.5.1";
	    sha256 =
	      "c191d63ff19ae177bf4cfba02303ae4552d8b48ec4133e24053e037513dfae09";
	      
	    meta = {
	      description = "Erlang Process Pool as a Supervisor";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/supool";
	    };
	  }
      ) {};
    
    supool = supool_1_5_1;
    
    tea_crypto_1_0_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "tea_crypto";
	    version = "1.0.0";
	    sha256 =
	      "0e7e60d0afe79f0624faa8a358a3a00c912cfa548f3632383927abca4db29cc6";
	      
	    meta = {
	      description = "A TEA implementation in Erlang.
";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/keichan34/tea_crypto";
	    };
	  }
      ) {};
    
    tea_crypto = tea_crypto_1_0_0;
    
    termcap_0_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "termcap";
	    version = "0.1.0";
	    sha256 =
	      "8c5167d68759bd1cd020eeaf5fd94153430fd19fa5a5fdeeb0b3129f0aba2a21";
	      
	    meta = {
	      description = "Pure erlang termcap library";
	      license = stdenv.lib.licenses.mit; 
	    };
	  }
      ) {};
    
    termcap = termcap_0_1_0;
    
    tinymt_0_3_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "tinymt";
	    version = "0.3.1";
	    sha256 =
	      "9de8fcedf254661bc4aa550aac317e28be35d4a5d91adf3fa3689dfad6cc1e5a";
	      
	    meta = {
	      description = "Tiny Mersenne Twister (TinyMT) for Erlang";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/jj1bdx/tinymt-erlang/";
	    };
	  }
      ) {};
    
    tinymt = tinymt_0_3_1;
    
    trie_1_5_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "trie";
	    version = "1.5.0";
	    sha256 =
	      "613981536e33f58d92e44bd31801376f71deee0e57c63372fe8ab5fbbc37f7dc";
	      
	    meta = {
	      description = "Erlang Trie Implementation";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/trie";
	    };
	  }
      ) {};
    
    trie_1_5_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "trie";
	    version = "1.5.1";
	    sha256 =
	      "4b845dccfca8962b90584e98d270e2ff43e2e181bb046c4aae0e0f457679f98d";
	      
	    meta = {
	      description = "Erlang Trie Implementation";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/trie";
	    };
	  }
      ) {};
    
    trie = trie_1_5_1;
    
    tsuru_1_0_2 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "tsuru";
	    version = "1.0.2";
	    sha256 =
	      "b586ad8d47799a086e4225494f5e3cf4e306ca255a173a4b48fe51d542cefb6b";
	      
	    meta = {
	      description =
		"A collection of useful tools for Erlang applications";
	      license = stdenv.lib.licenses.mit; 
	    };
	  }
      ) {};
    
    tsuru = tsuru_1_0_2;
    
    uri_0_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "uri";
	    version = "0.1.0";
	    sha256 =
	      "3833c3b5745fc0822df86c3a3591219048026fea8a535223b440d26029218996";
	      
	    meta = {
	      description = "URI Parsing/Encoding Library";
	      license = stdenv.lib.licenses.free; 
	    };
	  }
      ) {};
    
    uri = uri_0_1_0;
    
    varpool_1_5_1 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "varpool";
	    version = "1.5.1";
	    sha256 =
	      "ff6059bdcd0efad606e8c54ee623cfeaef59778c18e343dd772e84d99d188e26";
	      
	    meta = {
	      description = "Erlang Process Pools as a Local Variable";
	      license = stdenv.lib.licenses.bsd3;
	      homepage = "https://github.com/okeuday/varpool";
	    };
	  }
      ) {};
    
    varpool = varpool_1_5_1;
    
    weber_0_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "weber";
	    version = "0.1.0";
	    sha256 =
	      "742c45b3c99e207dd0aeccb818edd2ace4af10699c96fbcee0ce2f692dc5fe12";
	      
	    meta = {
	      description = "weber - is Elixir MVC web framework";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/elixir-web/weber";
	    };
	  }
      ) {};
    
    weber = weber_0_1_0;
    
    websocket_client_1_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "websocket_client";
	    version = "1.1.0";
	    sha256 =
	      "21c3d0df073634f2ca349af5b54a61755d637d6390c34d8d57c064f68ca92acd";
	      
	    meta = {
	      description = "Erlang websocket client";
	      license = stdenv.lib.licenses.mit;
	      homepage = "https://github.com/sanmiguel/websocket_client";
	    };
	  }
      ) {};
    
    websocket_client = websocket_client_1_1_0;
    
    worker_pool_1_0_4 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "worker_pool";
	    version = "1.0.4";
	    sha256 =
	      "7854a3b94e9624728db3a0475d00e7d0728adf3bf2ee3802bbf8ca10356d6f64";
	      
	    meta = {
	      description = "Erlang Worker Pool";
	      license = stdenv.lib.licenses.free;
	      homepage = "https://github.com/inaka/worker_pool";
	    };
	  }
      ) {};
    
    worker_pool = worker_pool_1_0_4;
    
    wpa_supplicant_0_1_0 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "wpa_supplicant";
	    version = "0.1.0";
	    sha256 =
	      "8a73ca51203401755d42ba636918106540aa3723006dab344dc8a7ec8fa2f3d5";
	      
	    meta = {
	      longDescription = ''Elixir interface to the wpa_supplicant
				daemon. The wpa_supplicant provides application
				support for scanning for access points, managing
				Wi-Fi connections, and handling all of the
				security and other parameters associated with
				Wi-Fi. '';
	      license = with stdenv.lib.licenses; [ asl20 free ];
	      homepage = "https://github.com/fhunleth/wpa_supplicant.ex";
	    };
	  }
      ) {};
    
    wpa_supplicant = wpa_supplicant_0_1_0;
    
    zipper_0_1_5 = callPackage
      (
	{ buildHex }:
	  buildHex {
	    name = "zipper";
	    version = "0.1.5";
	    sha256 =
	      "7df5552f41169a8feb1a2e81e2753ec4e4debb7d48cdf1edc77037205782d547";
	      
	    meta = {
	      description = "Generic Zipper Implementation for Erlang";
	      license = stdenv.lib.licenses.asl20;
	      homepage = "https://github.com/inaka/zipper";
	    };
	  }
      ) {};
    
    zipper = zipper_0_1_5;
    
  };
in self