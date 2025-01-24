{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  zenoh,
}:
rustPlatform.buildRustPackage rec {
  pname = "zenoh";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh";
    rev = version;
    hash = "sha256-Ydmd3eCXn+svMak1I5LU4rJNhzEEc2MiG5MoSMNOJ00=";
  };

  cargoHash = "sha256-AjMgnZ+GJPGMQsyeOQGyXpVrdw2zb7B9/KXWKlvKT1Q=";

  cargoBuildFlags = [
    "--workspace"
    # exclude examples
    "--exclude"
    "examples"
    "--exclude"
    "zenoh-backend-example"
    "--exclude"
    "zenoh-plugin-example"
    "--exclude"
    "zenoh-ext-examples"
  ];

  checkFlags = [
    # thread 'test_liveliness_query_clique' panicked at zenoh/tests/liveliness.rs:103:43:
    # called `Result::unwrap()` on an `Err` value: Can not create a new TCP listener bound to tcp/localhost:47448...
    "--skip test_liveliness_query_clique"
    # thread 'test_liveliness_subscriber_double_client_history_middle' panicked at zenoh/tests/liveliness.rs:845:43:
    # called `Result::unwrap()` on an `Err` value: Can not create a new TCP listener bound to tcp/localhost:47456...
    "--skip test_liveliness_subscriber_double_client_history_middle"
    # thread 'zenoh_matching_status_remote' panicked at zenoh/tests/matching.rs:155:5:
    # assertion failed: received_status.ok().flatten().map(|s|
    #             s.matching_subscribers()).eq(&Some(true))
    "--skip zenoh_matching_status_remote"
    # thread 'qos_pubsub' panicked at zenoh/tests/qos.rs:50:18:
    # called `Result::unwrap()` on an `Err` value: Elapsed(())
    "--skip qos_pubsub"
    # never ending tests
    "--skip router_linkstate"
    "--skip three_node_combination"
    "--skip three_node_combination_multicast"
    # Error: Timeout at zenoh/tests/routing.rs:453.
    "--skip gossip"
    # thread 'zenoh_session_multicast' panicked at zenoh/tests/session.rs:85:49:
    # called `Result::unwrap()` on an `Err` value: Can not create a new UDP link bound to udp/224.0.0.1:17448...
    "--skip zenoh_session_multicast"
    # thread 'tests::transport_multicast_compression_udp_only' panicked at io/zenoh-transport/tests/multicast_compression.rs:170:86:
    # called `Result::unwrap()` on an `Err` value: Can not create a new UDP link bound to udp/224.24.220.245:21000...
    "--skip tests::transport_multicast_compression_udp_only"
    # thread 'tests::transport_multicast_udp_only' panicked at io/zenoh-transport/tests/multicast_transport.rs:167:86:
    # called `Result::unwrap()` on an `Err` value: Can not create a new UDP link bound to udp/224.52.216.110:20000...
    "--skip tests::transport_multicast_udp_only"
    # thread 'openclose_tcp_only_connect_with_interface_restriction' panicked at io/zenoh-transport/tests/unicast_openclose.rs:764:63:
    # index out of bounds: the len is 0 but the index is 0
    "--skip openclose_tcp_only_connect_with_interface_restriction"
    # thread 'openclose_udp_only_listen_with_interface_restriction' panicked at io/zenoh-transport/tests/unicast_openclose.rs:820:72:
    # index out of bounds: the len is 0 but the index is 0
    "--skip openclose_tcp_only_listen_with_interface_restriction"
    # thread 'openclose_tcp_only_listen_with_interface_restriction' panicked at io/zenoh-transport/tests/unicast_openclose.rs:783:72:
    # index out of bounds: the len is 0 but the index is 0
    "--skip openclose_udp_only_connect_with_interface_restriction"
    # thread 'openclose_udp_only_connect_with_interface_restriction' panicked at io/zenoh-transport/tests/unicast_openclose.rs:802:63:
    # index out of bounds: the len is 0 but the index is 0
    "--skip openclose_udp_only_listen_with_interface_restriction"

    # These tests require a network interface and fail in the sandbox
    "--skip openclose_quic_only_listen_with_interface_restriction"
    "--skip openclose_quic_only_connect_with_interface_restriction"
    "--skip openclose_tls_only_connect_with_interface_restriction"
    "--skip openclose_tls_only_listen_with_interface_restriction"
  ];

  passthru.tests.version = testers.testVersion {
    package = zenoh;
    version = "v" + version;
  };

  meta = {
    description = "Communication protocol that combines pub/sub with key value storage and computation";
    longDescription = "Zenoh unifies data in motion, data in-use, data at rest and computations. It carefully blends traditional pub/sub with geo-distributed storages, queries and computations, while retaining a level of time and space efficiency that is well beyond any of the mainstream stacks";
    homepage = "https://zenoh.io";
    changelog = "https://github.com/eclipse-zenoh/zenoh/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "zenohd";
    platforms = lib.platforms.linux;
  };
}
