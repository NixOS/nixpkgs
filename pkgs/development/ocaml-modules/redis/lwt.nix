{
  buildDunePackage,
  redis,
  lwt,
}:

buildDunePackage {
  pname = "redis-lwt";
  inherit (redis) version src;

  propagatedBuildInputs = [
    redis
    lwt
  ];

  meta = redis.meta // {
    description = "Redis client (Lwt interface)";
  };
}
