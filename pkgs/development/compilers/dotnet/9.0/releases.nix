{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.22";
      hash = "sha512-snWs0fwNH6lifDVwb+7eOygmNWfeKuCO0zkSQdX9+qRjO8ELSwJsf2VJx5O6EOfwEDjJEQQTswM2Xf7uoacQ/g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.22";
      hash = "sha512-eCPoNbW+IW/Uqe3yzT79+9YhCKuw4bTZGn3rVrhaBrpbAqPrrIf47UHRU+zcdyHqWHu4QVY1jGgCdSqpfJc71g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.22";
      hash = "sha512-BSfQ87Wahavupw7Rv6R/d1YL6gzNG7qru9fPw4Fqw6Nxa57izRpr3hhpDEAyHhHfi90QGuhnvmls+JWTctRrbw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.22";
      hash = "sha512-bLrEiszvMc6sfL+rwR656xXrF5fW4fgdN7WceY7sFgGGeRPVnI1XxEBcM/ud2cQp2hGAWpRePqqdZOPsHTsJog==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.22";
      hash = "sha512-rBO7b3jKKiBUzYX+WO4hUCp+Y22vpPoKYv1PdnPY2c1Qn3JetSamB37NbAxHZcgH1BDUbvHBUzt7xYRloyFQNQ==";
    })
  ];

  hostPackages = {
    linux-riscv64 = [ ];
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.22";
        hash = "sha512-b1+VsAo2Z8LOHgmwCIllP9b0LKkC4uwdTVfJX81mI5gxKJYTJe+qYz3R4wKOjjcReAhQOd2JhWRcXs2AHiN8Xw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.22";
        hash = "sha512-jRXhhZXIJPMYii57gfT26so6CYbvd7SKtqfCT0lO4v/SRBXJ5Uy+KXun7sYl+EEsjcnbzUtM2g4ye773EIm/ug==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.22";
        hash = "sha512-/EB7zMnrrlKi38GnDZ/+ijwRxQyentelc9xV6TPKRubRQTiQaK6rEcn79WHi7y37jw1ybXRhWVwZarHRZlVxTg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.22";
        hash = "sha512-5onPGniG4frJJ9SbWj4xdlC5qJwQ4f/MZ+w3YurkZRS5JGVWd425wBYDog41O/SR65xPFNufhnm9F6pNsmdgbA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.22";
        hash = "sha512-jx1qvTtMvpsFLj4B2JAfI4T2l1NwgipG1RTWA9rufCX9uikqKxMCdVWAzgqDkigy/leTL8LXgaNlVPy10GWqJg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.22";
        hash = "sha512-jfKAoQFrOXZsntMe4vyqkFmBsT53sh3wfNkmLI4zZwURMOvDiaRwcpa7yEDWkMYqNjjZblkGv1/mFlqqzFWdqQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.22";
        hash = "sha512-eFiujv3GSHh7x3OpQ5WZgOWe+VFHXJvSayhz+aF0OdMRhUBw6H9s0flaR8+ZmJN3n/80tJ4QsKLBegHOdH5/bg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.22";
        hash = "sha512-wnz9HEOP+WyfrIZrMTSJWXG4NCxd5UAE2UKsUEDzpKlWeTH4pcLafJkBff5Fp2OKfrwS6wByp1bw2wmgGOUIXw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.22";
        hash = "sha512-VZhRwXaGKv8MrB4M+U+L2rA9v6Xs1eKS/ij52/+at5I6MZVhtpCDY9wppZ+IUZoXGsHw5QJmU/R1kqJcQZrTKw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.22";
        hash = "sha512-JwDM52+mTlmAx3bZ7leRIWkJd1eABF6pLfl06N584vuW9AXyKp/hU+I2uFqChY9kFyX9tRoLbg0YQG7Rhj4tqQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.22";
        hash = "sha512-fueQEw0gNeeuyuurvWBF0m2iPG4XVIDIyE4WIPDnNVXU16mEv68TAyhsfCe1qEPt+bgAfkzA8BFFYsBebeKpHA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.22";
        hash = "sha512-JnxWhAswvbbTy3Gaf+BUIlbc4uJdYhRE6buv767UkqRmix8fTeb+zRg+taTpX/64MK8LrBHx5g1Fps7hE/j4+Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.22";
        hash = "sha512-7eXqKT9PPd7rApRhr9XE7hXHJF8uY4L0RkVLX5rT6P+i52tsk8iS+Wy8Q75xEu+o3KLt1KO6m3tf2v0JG7Wzlg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.22";
        hash = "sha512-2IzpLs32EUztz0Sq0PN5LXPNHP6dpXF3iP3C695UZItq5Wu02AcrNpDe7+ujapXxMxUNE+yjBlf3nkAwu6i9dg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.22";
        hash = "sha512-Oo3iIBwU9U7urD3+4crcYEMe8DVH0yfOCWMzWXK31zOzCk2euTo9yJqCpYCNgbdit7NNlEcZ7TH5mILQEKZJiw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.22";
        hash = "sha512-tazYimRKRb5HiMu7eavB8la8fqWGL2HteQZ/xexcv/6NrPQHsD8D6WZipFuXAhKMLXd7PrdkuVo0OCw8AzyAvQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.22";
        hash = "sha512-hUzOhkENoBftDkgx5ZESlm3OcsQClFJ0uRq3PdtCFTI+wbv+vhy+F3isl9/Gjc+SurRAkPtzZlpzLCZzxhDeOg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.22";
        hash = "sha512-XDaIz12Bo5aVvT3AUmFheT+S+M9epOknCoSzENVj8a2HlkCiA9CZM+ZykrUodvd0+H9CqXFtPMyiRV40WhF+Gg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.22";
        hash = "sha512-t8+ASrnjxPThtKgit5VtWutFWJj0bIMaQpMBmEJfnDB2o4rZXl2rbl6AylyReLQYoDWaQeltjGkjQqK3Ug6J+g==";
      })
    ];
  };

  targetPackages = {
    linux-riscv64 = [ ];
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.22";
        hash = "sha512-+70djNYNNrdIeRwFIHKBUa9rOvYoqts9nMEk5MYXBBEt7cJeIbd2fJ2UScbpx3lMUPlB8G0Wt5mpoYE41ec1cA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.22";
        hash = "sha512-9BduTMj6XvHpAo+gL/B8XzhjN3yxcxwCRqYqFFuUWUTPuCgNKZyNwGJwdizhiaoeGz+J6CryDim+uaCLuJ9r0Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.22";
        hash = "sha512-7fEvQuA5ckEoGmIR0xQogOiBqnrj5xsbP9Jb0nga6Z/QJVVP6oJldWiYWflRtkkztjuapK1B6KvSvIIAF3dQSg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.22";
        hash = "sha512-jcKvg2PQzdWEU5ljEHoYnv8M8VMwRd2FNK8LSkkbQ5bZuJ+xZDlNKReBmXY3TqC35BbMK1RNBwOJ+sY4+u75qw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.22";
        hash = "sha512-BeW+hxuZIHCVQ2J/PB+r10G1eWOgVG288M4CHaIqybonhmrAfBOeZacLeh9YUoz9On4RVvBeTS3QrQlrwY099w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.22";
        hash = "sha512-l8U2r5WY4iV408rLv6JT64hf3cug9t/4HQHdUyKsOGI5blC9TZjRFWBDEO/tIqYBJYfFTc/XO+v5VFfB7xSiQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.22";
        hash = "sha512-hrKkJfd8pnZw1FteBKXBZV7ZocBI27zG1rF+AOskarVUruoWLfhJRCP0cEmkYMJk4Jj0YCfk/05HhkaRHhlFXQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.22";
        hash = "sha512-9qQ7uEpHlmyevFiLcPahiW3LA9teZTb2k5qy5xMTyE/xALyeo5hZ2ZCQ1gZfg0QUGuDviVnxYg2dltXRbsEy+A==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.22";
        hash = "sha512-smR1cG2Bx1FXZ7Vs2zTi/9er5R8gfFK1jGNFcMQ1tVduPZ4KDpGv1ppcflyw65XkKE27EsBjsfXjmzK+FJMB+g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.22";
        hash = "sha512-720YrHLOMQjv38WjJ+ZKb0lz0WBDvfGz5UZbxwyl/5gppuEx+YSuXq94GYrvYU3PMxBPl7ivJzqDpITp8nAg5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.22";
        hash = "sha512-f6zPJz45iWkeKmMNRwFOF8FNpiXIpnplg0ezy7DH3NwakSjELkbHpbIq5TMGXManAP6esRjcGJPKurs0jPiLwg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.22";
        hash = "sha512-/26ZC8HPXTicyTHcy6Gv48deXA+VlVUBODxMm5wf9E/avMUTEDf1WsR5F7ddqNkIYOgcNUP8e8+0s/Ks3gPerg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.22";
        hash = "sha512-mi84g7YrJGo0eXMf5PKsAqE1SGCHjXNGli1xjePIZNu0ZsRk00gD8ABtCaBspC/sPZlx13cy/NGjHKmftQm+FQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.22";
        hash = "sha512-42cEtBZeQ7VjuJwUE5iSXXDVDsNPCHEDXadFXgc7vpJTzD6jrCiiWN6Q8kx142G3bcJ3xGd3YJ3OtyU46AUKGw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.22";
        hash = "sha512-UzFkdoiKiJCsvb17BoNF2ljeRdpwTwO4hZ+ZiNYqXcoiLPRniiXzjk/6+/wNfNrUCvX1xKs0s7+b4NrqFaXfJg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.22";
        hash = "sha512-lnu9hH+ykd66tppBhq5DY6TJ184cJzFrx2vxXxEGBnIE03Bm0CImvOAa7Nn+FyjkH2HaFYndhtBLicJFUVG4Yg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.22";
        hash = "sha512-kuiOtQ+OO4+M60Yw6GXvmdUGIEkZE8lEpUC/rArFcY/mxmLk7M7fitCkbPc9PYlnXwJubrGq0cu5jOGwkrGjQw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.22";
        hash = "sha512-at526lJ7iNoi4XU5UlrzOaYDTYxO4lPEnByN1AT8u3NfRP+tNGZ8keWznn2gyHSVsj1fU4oiyTyCmaeAFxCANQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.22";
        hash = "sha512-H9NcS7hm3QoHX2lQVFjJhs8tCXY87K3pwFW24uOdEV5sxsrlGT41+u6hYvGdIXiN9+efBfm2WfUlS43NRBdp8Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.22";
        hash = "sha512-S/COjgW0eyl3A9vh5Diw5eoybdgB/eqZqhjfPlah6Fc21YOWRTMf15YHxhyBl+tB8kaA5JLyp8UDFXImteJJaA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.22";
        hash = "sha512-n/MKVYqHMTZ7REqQwZ/Rbww40D5AJt/tluLFxtpRwIKL/2lEgheMiQx+7GsA4prnrQx5j8WfuQadio7CNeVNRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.22";
        hash = "sha512-QSo/qjGM0D5mNhhTkjXrs0FyD4C692YSBhH7AU2Ly61LqM3/Z55A7QWNJg17nKPQkIPdW5on0XDKBXBdFzqWTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.22";
        hash = "sha512-ccweSXM22Gi5lBedje+oKNnFiCi3ZQY/BHMa5XN51eGEFnH76zffGfAyG5EhFMrs7sS/nez29f5QRWIAoIZExg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.22";
        hash = "sha512-589EW948b67EOsGp9+MHzQNrZZjnInI0rMg6U4gvqygn5PGLoETigwLbBATZXWd9/ryF61YFU05QSdibyUyLng==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.22";
        hash = "sha512-dEut2adIRs9oJuVZYtOk5yiDS3fuLHXJCxQ9u8MesFzFhuNh7rbxM4AQTzcFoFnEvpQwqBxV3JmqgrSM7rwsog==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.22";
        hash = "sha512-0vYrC2lHICNPs4TtsXcJbSLkkY9ALPUmdmlmSUUvlrPCNXw7VUWTBDAy+5ScsEvM1VTxgh2LrGlXJY34mOEPxg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.22";
        hash = "sha512-BrxjCW58J3yUd+v+RAUKkTlwyEOqkQCefaSlAcTFCGo8p5JIMe7IgJ9JV+oOCaNRX2eAHZF7CKktyovIim4KTQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.22";
        hash = "sha512-Pn4n7V02dQogBgN1MX+TwcBGO3gGWFgpszQNGF3FoEUmCmp3FoFbxbhaxp4hoszgNmB44ifO4/hzyAYKqgGaew==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.22";
        hash = "sha512-ypeRB1duSXYVpikYamGrs73yTOfbE6HiEqXgTJSTNKvfYJQ0DOfNdGH41xGDwDaAX3v/CTYQvpdWNZrFWFtw4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.22";
        hash = "sha512-wx+jnNBdS+wP73Mz8UlYnxaClg/InZt3P75YvoGq52S+OzkEl3GNHCZxfNpZE4PTt6SajJyh/E60+S0dRPNT2g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.22";
        hash = "sha512-ZfP8ipaqPnCSJPuwc1pn96pqoHbCOHuFkc6GbZclwcqn2t4C4MHZ7iTqYeIXQIE79tfH2dfNxUBBBxy/6dVC4w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.22";
        hash = "sha512-OHbfATmzcHMikPXRSe0T+A6Ehu2nJiwKSQBzfNKVMUlnBXoA3iSCW+8qBn27cBZNhu6R7+7UqJHLJ1p+uPY5Yw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.22";
        hash = "sha512-BO97ZPiwqp2xrMYhJwgT88E9rukvV7uMuhYeHn+JXuK3bgy/mOOQyMVczkm3+Y3uDIHMYiPCEJKXhlZzXtdO7w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.22";
        hash = "sha512-omJvacxI/OAG7jbQSq+WUk7Y8fCm2wiFW7ahwT0ry8YyrAujP/PgawGtkZCCT/dWmPASetoGogUu2H5yRc2s9g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.22";
        hash = "sha512-tCgmpEQryAOGHmf6Oj+4Jg2XsjxWEwxjTfHKdHld3AxAOdD51XonAhZyx63czCGnUev1sSvGlc/xvBLI5vocSg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.22";
        hash = "sha512-yw8TI380Kx/I/izbIIn/eb/J4c2R315HRl/uwJ1/oj5reLRyEOXf/wZKN28P6REV90ARwND0aONLehE+gLdxYQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.22";
        hash = "sha512-Uwy/+GShRRWYzRvmo3NbapANyo5CC6NJWeTZsRCuQbsrRx15eSKZkT42O8arRSHaAvrYDA/uBnv3JRdnhsLRCQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.22";
        hash = "sha512-6Jlci1/fOarVqkn9dK/ESaz0e9gg+1PYpk//ojRMJdbL9eaT4RZQLz1IALloKc+WjLYIdED/Uj4CXMtEMyDHoQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.22";
        hash = "sha512-lQ4B9IjWCa2OQRyZvxGd9OpyRvn5GBvTTrDO8CYpB7ir7zD33beCluAdEfvgOel5qmgfd32mnPxTiXvk5h1s4Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.22";
        hash = "sha512-PgDEC3+8AoFt5/nkcAAbFhZYUnBDx2eGJgu8FdMavH8gR3qMkX60R5XQSQOyVt2MFKFFs5JwHkJVhAj7G4QWoA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.22";
        hash = "sha512-CVQDyaCHh6qyymC7+YdE9AnH2MuZOyZM24nLFY5Tin8hz5HqfLDEdgmQj/KaVar7v9sLn0ZVI2B7gTGeXKFyoQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.22";
        hash = "sha512-uMy1uv648FtnNGrVAwi8Kf3XwL6FUQaQLqjgLkE0rMcHOY7+QfiDuDgaAVzZmcZBlbuQQV/QxHdJQqoK/dlaWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.22";
        hash = "sha512-MsyRARgDKzQ/s6od2UUTiHdmL9AuoLaJBncSf2ikZZNTj/CmbZs96cHyyVP6fB81ZfAmtX7LpXhJNmNhdrhaFw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.22";
        hash = "sha512-xXLOo9asAGye+7k3DI4Lb8BkF1LEtOui5u4LTXko6OwIewY9VnLf0DpsXqojFqLxdUALig4ibdv84KrcNX79qQ==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.22";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.22";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/9.0.120/dotnet-sdk-9.0.120-linux-riscv64.tar.gz";
        hash = "sha512-qbSFjTAQMOPKCla5J3jTVzqmpWWXoWIUWkTphzgE1chO9sk9+GMhYtenWF2V35U7UrwKOa/qPcc538XAYHyrpg==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.22/aspnetcore-runtime-9.0.22-linux-arm.tar.gz";
        hash = "sha512-inUAqBxg2n6ZpJCpEBBTAopdrAyuefRM7Pk4dVtEZBzNLdp2PfE9eh2wvIVEY5V1vITBsL+SXUKvZv2B7KN5Ug==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.22/aspnetcore-runtime-9.0.22-linux-arm64.tar.gz";
        hash = "sha512-7OzZcFqpUKrXty+omVli3yw82Q9aHllGDu3eMZkyHpOdiFGl6pFoL8w9AqMFMOS8Oc2SQfQHoB3Ap8Jgaw5Mrg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.22/aspnetcore-runtime-9.0.22-linux-x64.tar.gz";
        hash = "sha512-6vqTsISwnuWHc5u/rdoOSzxzSvpTCAlRAMejEM0mnK7y7HNK4n2rrlYxUOMLkJ5bNR+Re7RPttYI7YpMrrWQwg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.22/aspnetcore-runtime-9.0.22-linux-musl-arm.tar.gz";
        hash = "sha512-gJsuzl7g2u/+XgD40QL+rSsidQJ5k8dwc3dTm/GM8DWMSEpdMojmZuMX3IsunLoh5QAiHP8Tk6gks/Tvp5b+Iw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.22/aspnetcore-runtime-9.0.22-linux-musl-arm64.tar.gz";
        hash = "sha512-DVeRTcfd+EnGUdoFLnMDNe4LAQxoQNW/kP1drT9DmYF1oBjUXc6hnmBkhOwZOejcmHvla0w9S5ulyk8+VeF/bA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.22/aspnetcore-runtime-9.0.22-linux-musl-x64.tar.gz";
        hash = "sha512-8WibwR7XPmGNO3t/kMPjcSlXQHzjHeCS9tUn/3JDakUgcHuU+YoRZJ9vUh/olneplqKVoCGKrEp4rPr33MssXw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.22/aspnetcore-runtime-9.0.22-osx-arm64.tar.gz";
        hash = "sha512-IV9YJwIeWtkwNo9Qz3Z8V1ele2BgBKzW/b07v7R4+thfQsn7kGxXba6xjxASsXUQ14QlT786JCzI1QDpVxeLxg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.22/aspnetcore-runtime-9.0.22-osx-x64.tar.gz";
        hash = "sha512-E+EJLLKlzSSc8ALGcTbz0SItjR3kxCeHcAT/bztYSI70SoKQByQK2A9kLrlGOYXVoDOhO4ob/u0rVZbVoy2jXg==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.22";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/9.0.120/dotnet-sdk-9.0.120-linux-riscv64.tar.gz";
        hash = "sha512-qbSFjTAQMOPKCla5J3jTVzqmpWWXoWIUWkTphzgE1chO9sk9+GMhYtenWF2V35U7UrwKOa/qPcc538XAYHyrpg==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.22/dotnet-runtime-9.0.22-linux-arm.tar.gz";
        hash = "sha512-9w8w9XsBeNXjrA6sYkhdrqrTH8jn7QTobTI64isTjaFh9fcPVcbpPnyWT5rbPtGMKuz3wHqveRTyt83HfPhWbA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.22/dotnet-runtime-9.0.22-linux-arm64.tar.gz";
        hash = "sha512-U1mAqAqcbvUv5U1pCcn04jw1mvHvkKP1FOI8gBt/g5hrF5sYNCdg4XLQN1qwi4B37zxP83j8c4pSzxmycmt/Qg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.22/dotnet-runtime-9.0.22-linux-x64.tar.gz";
        hash = "sha512-xvA5IJ5LWCSsV4N/9B6V9qs8ebGhGPSoU5cHqDgd9G07LtmLvYk8yFDGgP6xjGTysjCMgfX2DlCSenayleXEAg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.22/dotnet-runtime-9.0.22-linux-musl-arm.tar.gz";
        hash = "sha512-czMOq/mXltq+UCCYA+iOjsjibdvCPfO81dGVl9+g9qqOubOJ+ETKFsW9+joL2CsSjvNSC7790eTYO6/PlQY75w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.22/dotnet-runtime-9.0.22-linux-musl-arm64.tar.gz";
        hash = "sha512-Z3oFoY0FImEeFTaJuetNG/570Yg6MnaflzypR2E9fW1R1zfGpKapvTR+u5/wk9AjwDPjGmrzXbgPC1/0M+l1fQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.22/dotnet-runtime-9.0.22-linux-musl-x64.tar.gz";
        hash = "sha512-KM769Dujtf0MIeMzHAhl6UcIDFwPlBIpO89ULpu6yiePGTcL3vO24idLBScJ6QqvazRH2Pr6NkTM+dlxXRe+QQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.22/dotnet-runtime-9.0.22-osx-arm64.tar.gz";
        hash = "sha512-k5U9uU5ZqmyJpRSrsC9/NcvNR1LGE9t99PkPXl/3+DsbqwcdPrmYu0sMVsqoDqZUgsfWLoHwbGaA4WT/iEFr+A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.22/dotnet-runtime-9.0.22-osx-x64.tar.gz";
        hash = "sha512-ApEDEewTFSAmHK3nE5rTb/efGVmoSZCb8sAg4HBLru/6Xk5BE+cZmJk2gHQLvfBcq2NSYNn+AspxLIz3CIKhtg==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.320";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.320/dotnet-sdk-9.0.320-linux-arm.tar.gz";
        hash = "sha512-70E5bzkxYczrk6z7CLlCVWg4tiE9YXazJCjD2NAPD9WXvVus3v2vAclCH+GOiwuncaFws6+Bumy2tR4A5QW8vw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.320/dotnet-sdk-9.0.320-linux-arm64.tar.gz";
        hash = "sha512-iNeL95hDLpuS/pPL/9rT/zzHs+k7ZAx170aiyqLU0Lbf3KAC/NAH1OlXJfLpdP+9ma5OOp15maV6Znq10A7w6A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.320/dotnet-sdk-9.0.320-linux-x64.tar.gz";
        hash = "sha512-6zcRALXEBkGoErNoO/2hdy8LaeUjIJEpPHFdSeuDf1IXS5uakzddaSvdv9HVcAXxqap3S0swJ2ZlsMCxqbZkJw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.320/dotnet-sdk-9.0.320-linux-musl-arm.tar.gz";
        hash = "sha512-ijggN+sueEqmBbjFXHn5BTnG4xlHk931l6ZIKdzN9DwCvyq+RprcRJ2OmLRIeQQ8dbnSjE3rzFPNLtEZvYGoIQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.320/dotnet-sdk-9.0.320-linux-musl-arm64.tar.gz";
        hash = "sha512-csgexAcDMYKc2fnlrsuK24tQ7TWiogDRRme4hiTwedMbFCx2yrFovhs8KkkEAZkJN6lZdaXPTby5tKL+kZAbEg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.320/dotnet-sdk-9.0.320-linux-musl-x64.tar.gz";
        hash = "sha512-D9b4I5SEsAJgC+pFbPzCtGsC/9Z3ih9cSqLsb7XPhTX78Y2l5PnpupQ5xhzezjbphDjbTm2YpDPXNyWZqGeUZA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.320/dotnet-sdk-9.0.320-osx-arm64.tar.gz";
        hash = "sha512-lxsBcArsGDeT2TO7jdx7RD2queH5UM2VFDxYZzOgq5FMhxlWEGwwvSxs5GzL+76RifzznswIVYDoPwHFmepB4w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.320/dotnet-sdk-9.0.320-osx-x64.tar.gz";
        hash = "sha512-WMS1QrZcYfXq6Q2/bhwez4pr00TrwiKOrFk2WWPPUnAffqP+agcCiqZSLSofqKFFfizXSqD+vYGSbfnyBh7cfA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.123";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/9.0.120/dotnet-sdk-9.0.120-linux-riscv64.tar.gz";
        hash = "sha512-qbSFjTAQMOPKCla5J3jTVzqmpWWXoWIUWkTphzgE1chO9sk9+GMhYtenWF2V35U7UrwKOa/qPcc538XAYHyrpg==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.123/dotnet-sdk-9.0.123-linux-arm.tar.gz";
        hash = "sha512-sS4innN0oNN6zEaqkNr67mS7mth3oZIBKaYwG2OsfWaManAcwU0CaO7VouR5UotxQeLwVgDpjoifB9h8yHETLw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.123/dotnet-sdk-9.0.123-linux-arm64.tar.gz";
        hash = "sha512-ZR3TNJ3EAiIOMqZxvIIXOWqIQrKbNt0JVV7+bV8hjcrOgUxQcmoKhTn4i41Oo7kzZzmzq0BnuISI8khSIBWpbg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.123/dotnet-sdk-9.0.123-linux-x64.tar.gz";
        hash = "sha512-jyv3RzPYgk25BZNWJo2/c8dMOHV8EW7KLtBu+P0BAa0EjJn6kh5zdOwbkHh8q9+hKI4APeuL64qWkG78zWHKTw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.123/dotnet-sdk-9.0.123-linux-musl-arm.tar.gz";
        hash = "sha512-k8PSn+nKxC2X+NIt5t/rNanoDoVP7a7sNQPsD2bNpK6zqNv8ScESui+r340KhNDp9svIPK99Eyy5uOMv4C42zA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.123/dotnet-sdk-9.0.123-linux-musl-arm64.tar.gz";
        hash = "sha512-h3K1/TkSz5VoowpNq2vfr5KbaTbngzXqwV42YSnfHk0c1FgUvw8RHq3GKi9IHyGIq08Mck3SJAmOOeTmyJzMEg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.123/dotnet-sdk-9.0.123-linux-musl-x64.tar.gz";
        hash = "sha512-zESHkaTd49DBFPIz1sDj0PkkFFzdTEtyvf9PQML656doDsW+wog+YEI24QgJXgtP/V6YWfFMBRvatN65hp63zQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.123/dotnet-sdk-9.0.123-osx-arm64.tar.gz";
        hash = "sha512-GQZo7k7OM13BaD483BNLRoQlhm+eeS0nTs+eMxD6H3OpSDij568fMEFb42j7xiTRMXnbe/0oNJNcOXp9gYxwOg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.123/dotnet-sdk-9.0.123-osx-x64.tar.gz";
        hash = "sha512-ceMJszSrro/laHwEv2lyzNbtaV0pleOTJs+60FkBRFoSwKAXEadFqhriQ75m9onQzCk7Me9M69QyppAQNKJ+Kw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
