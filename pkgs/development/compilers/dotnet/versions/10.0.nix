{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (go-live)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.0-rc.2.25502.107";
      hash = "sha512-hz7scU+GeR8opmEoYFby2mIzR6Q/4/XqKrb4XsusXHFrIFNnGiyuO6pYVEAy/AmUZ97YCy6m41ybzAuKLL7m3w==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.0-rc.2.25502.107";
      hash = "sha512-9qeh8T+LChz+UZYhAJcf/POP7WeLhRtyb4Z0+bmRnv0Xm5HPPmLqEy6zADiVU9aZyjPu9Ft0NtvLdcfzXT50+A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.0-rc.2.25502.107";
      hash = "sha512-a9Ul0tE8XV7ipMMHlbkhQPi6qpqiaYiGNZ9wTHJlQhDoD0AsKycbiYjWnsITXsuccOjAXGIPjnX4mwTNcD/VSA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.0-rc.2.25502.107";
      hash = "sha512-lXNTcDjyw9E47AZE0w0AoCRIls+nBtOWb5t/QTbrNX+OgawCGKJn5oHTjyOrZ38wR6YdWQbr8wi1/B/pwR7gow==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.0-rc.2.25502.107";
      hash = "sha512-KgEeHi54wovjvzjW6Ma4chuj20ux1s3dbuo2pvCAKjisOyc6hHS0Xr/LvAcnCKjafa0Q+HZ2IRZ+HS+O9VWA+g==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-pYS9JBkV7rUMaHEESpR2rahJ2ZvaJNsdt4oa8f1WuPFG45XJ/2u12IdV1vsuaU+9f9rYMVfhj0iux+2F8LYqFQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-O6kG5AngtMsrdyVCNqlpBUDcmeq3od7Ucg2xN43pyZOcwmLO7AHl49SKqniW5JyoZP4ZqWt4KwYM5mmw0XV3LA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-hYNGcBFVkmmJRVAryuSKJges5+CKfI459ksjbIkPAhUHGwfOQIpKcX+TppfE3jJmCSl+eQL+2lbZl1jiGHXtlw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-hIWTBNODFZiqZLtHrs9hMTkXIDIcacrcF9B05YvzeJp9+0dFJiZYH1knXpDoTos3O5KwDObfb2nq5YirPBAPXw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-GR4jPLadQCCaS+1DD2v+/MQrSC+hFk0G1yEw2BbhcgQtYgxM2GtEPNEUPoIIss3YmeCM2vjXZBgLZtS6yUkZdw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-YnnezTFKvLbmSjJSKxNU+JZDiz++ku2ZSNeTP0KYxuMKKXx0C86dR4xvbSqmB4aHd8SZk5Ka4UH6PUTDrEVT3g==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-F+jX7XP8Fs4E3Tt/HekmuL864IUgH5aN72Gt8uEEtThjn7kl26c/gu05R7pk+57GOinv5Ob/bkTTXOcCb3S+gA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-Ki53xQRuNgmsZ1sUaV41PMVABQKepRFEKsfUYBvyZy0e9hGDCV50wEcbCRhJj07WahcP7aMf7hK0s+yCtbp8Ow==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-V9tGJ2/s5CYJeu2kCJAImHrJ6/a7k+1GgFgAjbUXcPghEhQyqBaVkekeDQbEiNBQCqv2eWJ5gRAxZn57LHEGHQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-IYdAy1GSZcd5i9c8PPotMhdCnExU1AwLHn12WQ0UmGg3bjTvtgVuFen7dkFTISqJn5T/3AU+89QG/d0oJTlIaQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-iXSGPUT4HxCO0wxmNM2dE2phDcC4W5BSJkjn2RnA/FC/tAVZD6O1T6SuMtgeA8m9vVVrSy7sA708J+j6zzyOfg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-NOy0zl+gyoS8h1qUmNYxm/KSRWCd2sLAATH5KhFatV9GwGc/JHhJfWuN8oXaIWuHkXklWpsCgIE+BuEYpKUkhw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-XlncsgNGIi18zQe0A3ANBDa+KG1tB/s2Dmn0jfLsPMjbyYTJuUpmVZvNgOequimdiM+pBWX4tvVqRfsV5hImww==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-Xl4KiHx8RuL/DSAAcxMUh1fNtaRYIKwzqoUxN6qrjsE9A5mlWlsWQ3CXP/DFkP1ooWoQEH/Cyk71IHQCHCKZ7A==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-cTSKXdydpMJx2AC8n0wvrHSx0aoHI0QSxo81D9w7O8wrxrpv9B7gPKU2j8/gpe5n6gSmdjuYFTT9GTbt40wpTA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-gWcOAXM1iT4NkVnftI3njn5aqLRgn4DXnpbW5BtRBcsqkHHlamc+sSdWXltVweKIsz/jZbCrEiMjl8sYOS3qmQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-+itZL0t/HjXzRhKVFIvysPjiLRov9TY8U9SsuRE6JH47x2T7JR6u01z3zhYf6CF1N+omN4NqnxnUBTw+E9ubsQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-xxLmFZWpqUqIF5eSGlcJLFPTMclNWvPASqPdvLaiu8HtjtopoFC5u5Y2B9529XXJS3TZmaPQXkeiOscz6ux1fA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-uMUck4T50qnHf97xwLxsy6MR93BN6g8BvXFXfILFwPeN/8GhmXBJMOqRf1c7Lobt7+jHlQ3DYj0/z1jVwjnJlw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-mbrXpbknOjIMa8YNqzHO1HRP0V3lgHPGzFNYh+/VMmer1IqVt4FmlR4BjMeU+jfSW31gtfvaDFqu6YfKhobstg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-bjlIIxeoCrqrnEjsk0wbzGTSv+BhdUR5SnFC33Ar5/CwMH33p/X+WWAe3Ac6hQLVdxeIuRrbxgceDsf3Hn2zIQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-j2y4ZAy0wnEAoOsteO4CpOao9Hz0zcvyeqENoGG4HMrYivzYQmXDkM8gGuKO2c2+77sSNYa/TjUiU3oE6bCmxQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-G9AQlTjJJlOoqC+IZzaSzg6k0GAdXXeywa7rcMRHxtSuLeWoVakM5gBYwvJnWfSJ1kqJlIo67neV2vvBqwjpWQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-cIucCZIOGtVkjsvyQYuhPBBonOHwD2oGGSJNkizjXXHJ1Gp1/sIrAXPEg62k3uyKWPsiFqBSgsn1Wes0Wd0mSw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-2VertB1ttEHJARtDySmH8Knon1/C1ZKho060g0Dqj0I2opdm6bPglHm7fwmVZLZNzWPUzk6j4OEs+0kdHEDSsw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-tQ6OaYTMlWXON+cBPGC1IVnveaF7Ctwc0SdoQzKN16icMNdYTD8ZHMlkcMYWV1GrPHXH/Dew63IeP6bpt6nYXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-rjTcmCMvPOqxLpNWP5lot7tnK8Gk3LkWCkC1xhUJj0WWnCIkbrpa8hlusirRIiR2olKJAo/z2vzdcrSqkQe61w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-hRN3Uh0q9iu23qVFrPeOch3DdgkFDYRoGd+ApvmRv7p5w+lX9Fkxfu2m0BMV2o0QgbWDIlLZOKZq+AU64/3Dvw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-zemzdje8OMIrKzAePlCytq2akcdHs5YevVqedUSLp45z8SC6+058i/vI5/WeM28hQumAjFdWQz0jtEUC62u3xA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-i6xet9EgM3zw4UcH6OzlIc4FaqODYS1hBf1LBvdKmIbFGp79pkCVT/s60eV1fu1eTQk4/cH4u6CCNdA/+jTDAw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-2s/iuHKVirb0v2UV9v0D2AzmJS35VM3x7nB98Aur2MTq9gK1Y9CfklQErsZApPclBdzThIXUKdFYVHOZY8as9g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-5lbYjjFzasjYa2NgNTFR5OExu6xDOjBteaUUv1efVC1acJYa6F7Sv8y9Duzq/GHB2SCnFr5e2RG4duzVKUkqkw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-Rxo9qZOaGprb6qXsLWzM09CHk5YiG5LwuuRLTA5r+ZymZnyDpo7VsmT2p97Hr9abmFe04inezbeItoqfTat7kA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-gfO0It9AMdlFTffP5g+ZJrbyI8Ul6aS8MKwb+xNrVg/0WculnWhsFL+r6hIeSo+0XvScIK/rj6ukg9bF91yGXQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-2y1TmuKQeUeHIl35WTb8liWu8m2LD+HQq1HSSvmB6Mp/BCJjleO2TCnWPuuAh3P0FVKn0uK60CdgUJ9MOJqrDQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-MoImFJInSf4NYK3dpOIRgV0GYHLm69d1jXvNodphn6iV+PdsXX1KuGKtKhG4AVeO8Yw3Fl7pgxHnxsR9c5eqmg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-7wr08dBr7MK/SXrWzt83fwdT7xyH14SJXwsa5/Mwse2k91zu43QJu1S+t7ahgwn95pVsx35pzZpkGD78ZXO9OQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-l8xBHbdF+yDgIiljNCMJGSqhFITeB2OiUdkaxkeSVRcMEAKpz6aBOtMgvbD7VswH3zKX6nA+kdpjWyXXtdIP1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-zXMQ4rzOYjdBPKLSi2YagXPMylYbusxZR6s/6NuGfgCnUNiaJqSmHv7SUsusDoRaR4kaurHVoHKn7P1/ZwNDXQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-+OILb/rE2p6IlAE+2kd2fi+aowKz11Ydn/2e5HUmCOkGl2JPs/fx1WNGaFtFLzPGeL3NnRn9FDfii/wC7SWAoQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-Vl5f7lYlYbLd42Ivc+rcSpqXsTkdSVB2PIjl60zISBZ3pkC5zo9K2WEb5SreT9HJzS0Gccn4MWa8CtBINJg62Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-IBScSHBaist1VDe55jf0DI9FXnCs5sLz+gzznK5Da4AP4IJm3ouqp3JPkuwxVIManPfXKpTcFGb61G6n/zl3/g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-Ng5H5Hepl6+6I/qLFGCYnHwlr9t4UAk7zjksAmK2PIVO2dz60AHY8jijDHPtZ/VF/C5YtUi7qOos6KUu3rHyiQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-9kfX46cD/zco4hUhEYEesn2zhqq6cTqKGYcNLiwQVUp5XJl5wwcsIGqQ2lA55YC+ZcecFCicWeJu5bgTNn1k+Q==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-mpE/aLq3eo9B6MX+EGWEt/bSFfB1ZImIIj0i1fMsHjaVRwLTB5E5xDbQzjJWVEHr74F2FJISz2dJ0qC/wNbjtA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-TknoBknlA9KSB3GbabdjxGHX8xNCtuKM+hA/dhwUSyUN/0aDwLuuF5/pOb3q33AxPAMcaubKHcqpjPSiyuFKZA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-fPUXXXvAGqmwme+EnEhx0koHPx/nIgZLDjw9wLOQTOOt8HdQboKebk77z31/mM5lDgmruUEwfOEP35ZnzpEdKA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-ZMmkniq9nGb6HmzdHgrYqUh4KAWqPS3LQZXe0c/TL1U2AYaM+go+05kkWYSD85phnmERUHDmgMEDo1zipqOFVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-UHHIErnjcdbTe4ZSGoJtDZ6PrErZCLpwRBDtE6/wARb5jBl39jXzS8Ol+MCpZ9sXjyPvuv8sTt7LVmHkdriRgA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-K0a2aLkcdAzrnHZa0OXcKu8i6Vpw4BYLqF0jK56228M6pT6W1wiDQbolSo0a2tU2omjQTAS/Zpxt+BeH8W+6Jw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-l6ue5zHQwXVQeFTO+knYTZdfdaMMaK4k3wHidQUQ3foIA6y6RSdBx7/UvkVfQMNJijyGgOK/oliNa79BItBV/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-G0rQT5lSuWK0gQXzEdwHU/Xs1Aa1xF8VNsvSpb0o/CUYqI6oO02HVHA04+cYCh/l9lBMrqb6uPSfUqDzhu2I8w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-CaTNddVLNUsBB32zjgkGUl7V9nlaIzp03PF7FhM4bIprWoZZ8RqYJB7Nte52W1XTiGqc1ss/0CvRFCaGnTK8sg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-mWxo7u0R0Hl7D9E/SNp9Uw1AiojSojv1j0aaDp3OEIHKoGi3iuzYu8Nsts/9D08Ec4vk87TY0jrreKxyHlvJKA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-bWUtvQ9r4yN9q+yT9EQUWUyo/KnStkvCEo1sfmVZily0aAjcH4ZT1B8qg1KG5IjOdHE9l9orqD/tY0QA7a1/Vw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-he8tZSRxjBEYYFD5BCmjkb8AGIiE+34TPMX9d6BmSHTR9Z8hSjWR2FBSxLo+1+ePBvnWJj4+Mgt+bg07tGU9pQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-+WUulk3XUCVctkBZg2sU5DTN+94xDu0KZoZjotxu7y8o0QDDzbc0l89QobAXv+HkH/5VPL+03hbTW43V7zyVgQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-bjIe19Dvrr1zm9YjOfu1XUxgZCFuEDs42oRfo7Wp6gUQWO3VMSz7MyG9hNWCsa/ZTZDUi6AJjpwIRyCXqEH0QQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-k6/cqrVhhdxR9+xWomz3kbmBR5gbzrpfckUEofY+Ohj59MNdmVXmPCECz9myA+XAkFAY0vQ1MViqaf+TuEEuoQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-ldyfSWeDI4RkCY6Mcj/N1KcPAMZKlAcEryoXnmTj7oh587JM/usoVNDe+a9EwQMA69mPga5d9XMkRk6zCsGNDA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-CYQAD3jv1uXiNLxd5aNVONW5Jsg3pILM1d4hSnPNTT58cUpJBM85ad8CiJJQOWnCOIuynthIRZEazf1zs10AAA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-K4eYnEoap+fFlDmPVpHQ35vKj8JAuAzBst8EQkAxRpnMYkdH6PXpUB6VMLfs/RT25fiESgEoFJjmVcJ8LpngOg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-/ffNVsL1eWoQB8I2O2Ehiz/e6B3KwesNAvima4B1gHgrZxjwH8HOdUCx1jl+OAt9A8IJckseCWlvATy0MRBugA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-JM3SUjoC0qYmZjhqPE/9PuitA9uYHMZIGgGYL42DEvpb3HnPz2j795bITCW0O9Yi+OWCsaWEK9B4l2pmMY1W8A==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-zlguqkKffJpKnIVBe0ofS87mkD951sUxRlCzr7isu1IjvKDHriwsIx7wxLhsjZELXDuI1HlkV/7Xhi4cludhyQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-MagJHz4q0OewlKxt6KAl2Qtzq2IegXeMWtk3bAIE8WFoDtLl1LwkOF3xnfEp+F4gIkv46jrbVNPMYqbQ7/yq+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-vDvBho8UNgWnLDKjOeKjAG+2a7kGJNO2XSF4vqOFTetEduXE/U9bFA0mCV+oDborDg6toHaFqctmW2WhbSQ/cA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-z+WtgZVatzoNkznwoffuv8tKjy8Nz7WA9fIYnxYne6EQ+ptOR8RppYJgIAixPB3tQ0+BpO2l+YtpI6kbDSXXbg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-9VW7n8wkmweyp/87tyRSL0Abmc7FIZrbLIyrH6LiOgALNPkaFIfSJgxmDqur3MUTsQAAx50iM/YA0+lNALIq6w==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-kjRe/NXF4CPbYAtPfng7zVkwIvvRSqzzylUMiZvxrotuXHUpDD5K8qXM4F6+XUQrzxLlZRZUg+OKuxswpFYU1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-nYinKgx3/v4XcxNUmS3xyzF7LZbunqGCa0311lMC4KAVuP4fXqcUpBeV1HenBMVKnmsKMNa6blHVRebTNDqT2Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-qQnhXCUI8A5yD3w7ElDubv6GNI+FDutjWvWqB4fxXnGAcPmu+SNEWfmSgYVRq4LnL5Nnj5ZSsBePOeXirv9HXg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-wmvYzbEsKYDFAeWBsfJebIAuLtolrkDDToxqO8BW7KEt9zoeqVKeR91uAWcW5kyd6GSc4WpTyU7oXCW8jMx9bA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-2j+ONnDhOIcS75JLL4OGZj4NJnha5si4D8ylnHWsJi5nZ5jGfHnuABpUMOn2T5yaw6vUPyQc6+e1qYWUW7NuQQ==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.0-rc.2";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.0-rc.2.25502.107";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-arm.tar.gz";
        hash = "sha512-RXOXwcFuMTHcNkKezwQUwnjnbnqwVhNill3BUplT8zQBzMnivYJApuPQlxG5k0Ye6h+JI5AeE4qeGyZ7hCMclg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-arm64.tar.gz";
        hash = "sha512-4HXBe9WZLPaqsfi1mGRaCXa6Qfz8dBTn9z8l/pZk2bFF1KYa31DCF0GPJJUTE3GvBejfTaeFjHKsSxOmeRB2EA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-x64.tar.gz";
        hash = "sha512-FAO6wy9LQ3DWZ4QaOkyr0R4zDrClSRiUSR08QYxf2c53ndYpgAlHqx6gGOWnJg/O538gLij6jBiW16AXfQOMfw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-musl-arm.tar.gz";
        hash = "sha512-ahZGywTD2ZEUT2FfFsyszICvtaBX+dlmIPmr24qvkXC3MZOWRVsRk6b793U4UWurEVVF6ZrpWY5qXY7FD2ZeXQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-musl-arm64.tar.gz";
        hash = "sha512-ax3VcSTsMrKWKOzfrBMjf/pO3y+fKwT+w75qfFgRNmDgHlSr4qR50AJs6GX13lPFmM0yhL3crByBjo35vx0XCA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-musl-x64.tar.gz";
        hash = "sha512-vrVCuMUmveGoriyyKGwJlmpS00KJomVpjDJgAQCoNzq4hYqEVBqEP43xl5YEhURcaAk+sDvctiwjmOKe146HUQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-osx-arm64.tar.gz";
        hash = "sha512-nydHh5ePwdcun6BZDdQY0yIDUqODqQmFTQvbgqfDIxZU4hSW7661kCiS3Mo/JvEz7B3yY38+hXj7mcjClQkBXA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-osx-x64.tar.gz";
        hash = "sha512-lVKMR713KOs6wRK6VD64X18QEgU+WGxT+VKbo/7phAmA29Hl9+0xTaTh2gXQrz/HsXVKpx3Bq4s+53/mO8gVCA==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.0-rc.2.25502.107";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-arm.tar.gz";
        hash = "sha512-DJXv15WufpXB20TlEJvX/BdIelELi+i+HwB5uAZmxa+qPtqAN0gWA9Cqz/0l9pH7z6OItLlXc0aQHGMffgN6EQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-arm64.tar.gz";
        hash = "sha512-5Fua/p7gZFDY0mNmJdCiJX5ABdn0RIQ2Xcsxs2K7tq9Q7VqSQq210tlzoyWeRE3CF/reJbqZ36B+wCFd/qwvLw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-x64.tar.gz";
        hash = "sha512-hqcTeMqtJmJuVbT0fLDqEFRK+lqt29DzPZuIsf2fpTJuKsZPnf5BaYS6E8GJNpDP4Ek94D7uAdqGXEtVGT8RwQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-musl-arm.tar.gz";
        hash = "sha512-ozCEpKgdIi8lrnOWZHGOXGdo69vWKsFM0eD1cOfF5MWB9ou67WUyHE4G3Jp9hf9gwNWf1VW++RqRTzM+o5Nt3Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-musl-arm64.tar.gz";
        hash = "sha512-I81zfdNIDK/ZBhWiLzbwrK0rpXgNhNDke45jE6SUvYK4fCrROr99kQ26jkTv6zZWgJ1U3MRsIwhmgtYWk3fdBQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-musl-x64.tar.gz";
        hash = "sha512-eplb4vU0ro3ZzuzXq7q6WyJ5ujbdkAcUHx7dbfQSFK4WNrLIxaqtYCoStN69o+oVzocWljHoiGiy7DiHBNnIxg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-osx-arm64.tar.gz";
        hash = "sha512-e4Z16OTkJMXqpnUVO32Tx43tSu34R7EWt6d8/itpKoxi6Lwegqhg+FAG/ZBHN5GmHtN9Cep+m4SMcmT8ma0mMg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-osx-x64.tar.gz";
        hash = "sha512-gEKnCKZlrfDgSDftoUM/zKBzycAIYZbdHPYMMQyBjs0sJXU+HoEHfJv7KvNkgxj8fRABfXnJG0j0KcE/vfeTHA==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.100-rc.2.25502.107";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-arm.tar.gz";
        hash = "sha512-eiIncogEsBXQse0KJrkAQrbqcR6nxEMAsA0reWwBSalfX78wPMzBXQVKI44Cm9ANetxzSvA2FLAGv8eCk8moOQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-arm64.tar.gz";
        hash = "sha512-pEEEWfBX9/h0DLH31pZSe7pIuoZLUZ51e4jIYitPwxK6ZFN3Rjdw9y0aslLd6Y8Hi+3wzVmv3gxRm4I67ijmww==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-x64.tar.gz";
        hash = "sha512-EgD/M9fCqDRJlZDgX0bAZdD33B91IPNUA7XU/B+wC937fEquIwKA6NxokP5fxcpzjepHiQVmFO0CqE0ehtBo6Q==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-musl-arm.tar.gz";
        hash = "sha512-tNgUQhCt+jwefr9wmNgUP/IjN0wjHjqcO5UjBg+P4CpaAkBJVEjRl95sm5fKta954Ofhnl8p7FSp31WvFeUQ5A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-musl-arm64.tar.gz";
        hash = "sha512-73pA0+ULVFYs+gUrCxXOTE0we0dYdAHtSgshPKEstFX6YO2hR1pAgBtVblMP5GF3Cjf4EPskZ9MLVOkmKvzNDQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-musl-x64.tar.gz";
        hash = "sha512-oxvqxFB36unAENrLA/UvZ82A9wvzrssCy0pdAN9HfGDSKeOU6cWwknHyMRlyEW8cKgmrwEBARSB0giys1mhLdQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-osx-arm64.tar.gz";
        hash = "sha512-4qjERriGb97WCmbhT4kW5bbUcnBxPT+b/dUIvo8B0D+EoldgQob3Oq47T8t9KJVk3Rvc6E4HoDz6HkO2KuXdvw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-osx-x64.tar.gz";
        hash = "sha512-kZVpQU9HhCxahNlq+WXPg41YgwvOW4f2dHez9N8OYL7O3Rz7PPUeBKZLl4PDlE3yjuTe4uSRi9TIFFICVMo58g==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_1xx;
}
