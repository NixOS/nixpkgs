{ callPackage, libiodbc, unixODBC, unixODBC-MSSQL }:

# TODO make other drivers from unixODBCDrivers agnostic about
# the driver manager and import them here
{
  mssql = callPackage ./msodbcsql { odbcDriverManager = "unixODBC-MSSQL";
                                    odbcDriverManagerDrv = unixODBC-MSSQL; };
}
