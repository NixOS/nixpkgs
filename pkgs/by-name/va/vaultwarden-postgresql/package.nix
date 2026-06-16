{
  vaultwarden,
  ...
}@args:

vaultwarden.override (
  {
    dbBackend = "postgresql";
  }
  // removeAttrs args [ "vaultwarden" ]
)
