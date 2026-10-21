{
  buildDunePackage,
  lwt,
  lwt_log,
  amqp-client,
  uri,
  ezxmlm,
}:
buildDunePackage {
  pname = "amqp-client-lwt";

  inherit (amqp-client) version src;

  buildInputs = [ ezxmlm ];

  propagatedBuildInputs = [
    lwt
    lwt_log
    amqp-client
    uri
  ];

  doCheck = true;

  meta = amqp-client.meta // {
    description = "Amqp client library, lwt version";
  };
}
