{
  vaultwarden,
  ...
}@args:

vaultwarden.override (
  {
    dbBackend = "mysql";
  }
  // removeAttrs args [ "vaultwarden" ]
)
