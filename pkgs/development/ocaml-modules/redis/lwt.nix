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
    hasNoMaintainersButDependents = false;
    description = "Redis client (Lwt interface)";
  };
}
