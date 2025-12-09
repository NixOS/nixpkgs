{
  buildDunePackage,
  async,
  uri,
  amqp-client,
  ezxmlm,
}:

buildDunePackage {
  pname = "amqp-client-async";

  inherit (amqp-client) version src;

  doCheck = true;

  buildInputs = [
    ezxmlm
  ];

  propagatedBuildInputs = [
    amqp-client
    async
    uri
  ];

  meta = amqp-client.meta // {
    description = "Amqp client library, async version";
  };
}
