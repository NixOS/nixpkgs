{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.23";
      hash = "sha512-txpauNF/yPEe4HjyDRIbdUMe8pRB7F1/VZl3cT9Fjg6g1R8sWUSEHGfxbeaUdmyz+OhjZBHExHflqSnUxBmL7Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.23";
      hash = "sha512-3z8R0nuwSti92RNRYR6k9fW0BQ4hHxUbHa9eesQzuIbvwBkh0mVHee7YGL/afAxYIDFVoGeJLsz6sHsCbTRmyA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.23";
      hash = "sha512-mud4VhICjqr4dRAjPRS1F4b0N2J1HLrEmubMJwlkpOHh6zM9UighqOuyF1ITIabrPoRFiljUWUFgVYjKH91nGQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.23";
      hash = "sha512-6umaXoRIvHjUtOv8z3Q03GO8yVx6mvW7FkF/mQv2QZ7aN1M7nYx/gC139C5jvRtPjI/kaRft7Ag1BmRn1/PdGQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.23";
      hash = "sha512-GhIVjQRLLwkVSpcpfAufoHn0CjUpaHr4Lnx3iz9Q/7k0YFWeBXzsLmHrL464Y7Ev4iws3OR8y+xVcGW0W4MO0A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.23";
      hash = "sha512-xlcRNuNFG/xcP+gK11vtI2DOvJ/iySAg0dwkaGwSPMVxnaMwq74VNrihEpdtU2Zbm0nLtMq43jP9XvHBfZc7WQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.23";
      hash = "sha512-cQKVYncg2fWK68CSZNxG1LJwFRHvd4yabZggpwIYbGTwFGJX591ORjusK5WflOedyjnaoLU2xm9z8L8v4Xaa5g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.23";
      hash = "sha512-m1OXZxCah0PbPwg82VYVCTFzgN6c5pC28o5Oos7Q3tOEnzXuMnlQZs6fKKMyKWyDkXrG1hxqiwYCR1IWVi0nhw==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.23";
        hash = "sha512-z5N+N6Ko4CvAzMQDN/7U9QaVMiTT439wPCoNXQYnQJ/NgbvLa3DxbFndz6bLM1fVSpnbMadaZvnAhZZmXvF7JQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.23";
        hash = "sha512-jzf/ppvu3K56HOmLdQCfqHiRx75LaJeYxPcdzn56v8KEf0434MozJYD+e3jBFWu1yFwA56OehWUuQVggB0fYqQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.23";
        hash = "sha512-CTthQo+s71E/VlI++hei4Prg5WS7klZkzHxYfXgniKUpCK1aD5KCi7e/b6BCTTeAXQajAPKlCjg9kp1YfzUTUQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.23";
        hash = "sha512-jcZQwgo8hu6ALwb37EDu1G77tZqKJ033DtAhF1VHTS5iqzvt72xRwR6xAVYwsXysS250Cm6tenfPI5Ia3b+YcA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.23";
        hash = "sha512-pYMtRS1tONoOj775xcGKue4jMxbK2pzS25OprET+IoOIiPe2w6DDHUrJlFBnFbVz85lKSpMlbF7qZNC8czoc3g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.23";
        hash = "sha512-ioM4u+XLS2HJfhmV7wfpIibapYlNCg6QjeJRoVa9MyDEtPgKB6kpMAXoAqlQ+LtgKSXn6oqBSvnMO80XP5F2Jw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.23";
        hash = "sha512-onWvg51HAv0S1lD3RKRqXP1wESqEZYNn9UyCntAiOaXYizlUQXExVyP+EQM404ae6uhSXBmTQy9DqmhVLIZ4XQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.23";
        hash = "sha512-TZcMj0sh72niFfIJJguIcUf9K5f0kytDcKbBUIiKNTOui5wqjC0GzbcMPXzkzqeFHt97P6MjQrqq5GTDjGeKNA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.23";
        hash = "sha512-qnAzZMa7XwfIdRIs4P1IhL97qhv3NisYho3Ac+Vhf5vJqL+Q5Wwh6kiZTMQsl6dv7CDa8mVH3eBXaOrSA0Qc9w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.23";
        hash = "sha512-7J95nd+iU/FYFChIBbQNPXd4klVNhEQaEAkoJmbmAoZa62TQFZhxU6CACxPAjiQKXdV4QC/RbOk1xZLiAuu18Q==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.23";
        hash = "sha512-HhXkurcZe4L1ECgsRJSn0Q459Lpm9J2CMdpM3rskbR14dhdJXyOd9jz7uBRXmKRRm0LLatsmdnrb5HwQ/aX+cw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.23";
        hash = "sha512-s9AK2qDsrcb66VBpnv9p6xnzWFtnr2VEFeMAgDK9aSR1tmLojv7lKCaEVPHWe/eHUwTuZq1/kpeOFtKADHeG/A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.23";
        hash = "sha512-6PoyZm3PTrIS+7ZJFDi9Gu+Xhd2lRDSB96tBqB78uX1K6B4IrSNk6Lp7HyeuPLAfwdANgQzh3ZbRSgwDNNfh1A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.23";
        hash = "sha512-U+xvsODf+fH2VcBZsZRuftOkzSL1E+7D8WRSOEJa4srAGgFWflWzX5M1Fl2UQgeBEcQeGK5I2h7MSpEZenLh6g==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.23";
        hash = "sha512-4m+7o/99lP5Mo/YUixPdDKTC9bmfFZkqeTWLF2zegSY5uNwcIJWYaZZkwn9L4j4A2fgo6WrMwX7v8FN6ch8pKA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.23";
        hash = "sha512-65l1yENsBfqY8Y6Ppmml5qD4Li+pgFgAKW4WERBpNcjqmACzRKljc28mofpZdjlqeoi8738lFcNVjrqWu6bufw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.23";
        hash = "sha512-ljKu1RVbPRxDn6Bt6FMbYAlsORf3M6W6SSDJdEq1h+uwxJA9dyILeO/BBVasj4L6hTX8FicIobLMWhKwuhaWzA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.23";
        hash = "sha512-Y5eddpo3DV+wwtnGFbSZbwuUDn248cDKjEcgkScSkT0eIccxHT0KVXHP2BS9omyqSfG6WFmXUm6PE1eMfHuPGA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.23";
        hash = "sha512-3iybh7PD/M4SzHhU5kS3OPOBq2x0T2vvJNaP78cdv6xJVLBrBFbzaLC5J8sYEyfNrK98br9DBaL/P54apeyZmQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.23";
        hash = "sha512-+vTriHfdk0vzTx5q0dnoROob/O4zTB7UVimqm5sf/C8okLjRe3FM9xDOPYZT//ResVNEYY6UX9oQoUk7TxLEFg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.23";
        hash = "sha512-bo+wr/Lhq0cx+RLCF3cvO3kbKansXnnvz1JRABSgMwBphfyq+FFcOGGbPoamepYHSAwKsTHESRMlfAZTXg2b5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.23";
        hash = "sha512-B192WfJUrh2kt3xOCvXpbX/SGgm6c2puizFTV3WtkZRqxyBIQVDaPqMfwCQGZmYPSnWn5MGfztmAdhQBPVd0pw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.23";
        hash = "sha512-UbFAIh6+MJMo41T+G/Dj3+ftOZJU7DlM03npnliSZnkXdMKwIcNnAVHLaw9PNfmrjumDFmj/nj+bFX7UPOyU8A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.23";
        hash = "sha512-57QSDS3XOOBZqt3eXuKqU9zEy1l+2ZrAVDI0bkJyXDo8RD5oJpeYzlzlloh3G7rjbL3pb4S9r1QIzGTdpN18cA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.23";
        hash = "sha512-PWOzKeJ8r/U+CyRq8bej7SKIBox6+ber1yPzoC0lqlQ9f4wAdu7ivMMKk1S3wt/m706/qfRDvBSA4N0Ws41emQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.23";
        hash = "sha512-+PDvOCUzIXVaNke/He6p/LQ1KRZrr9dKigyfqYWjwfDdwSt45M13v7GcmP0R0rHjaI2LcUWBOoJH/WxAqConsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.23";
        hash = "sha512-p74P+POMl3fE0LDowvNw3mSdqgfFTL4c3vRantYVozR8Eysg3JGvmp/BOwt7km7smAhfgQxOiTxhTTTu0AYbQw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.23";
        hash = "sha512-Bgh9xXe4gZnQSHozx/Msp5BmebjZr6abERrYXDMvFtvH8FP9ZUrOFchZbtq2Csokc1CauEaAiOga5vW3croDiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.23";
        hash = "sha512-MlTzEj8mjr7YBE8odoKwWnj6+ZivNYm+wH7WVAuGhhNtWZEtrxF4uFBAbSo4bZG+Za3hM/dcHKF1MNZBzPEy5w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.23";
        hash = "sha512-o39YZJ3C8yqCMz96NXIludw2m6/JFOVjDtPUHoNDjzNnUICMJGSJqqbqnLWA+gglQsAaampyR3u+Hei1apjEYA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.23";
        hash = "sha512-bQ89GaHCNupBFxlIEwtK2dDr3+9Is8vOGcFFTNmRCCgcuj6ADSsi0SNMRbnQqjI9LDp9L/7QiAqG+E8ECOLJeg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.23";
        hash = "sha512-nV/3hd7jUot/n5E6xIoInKxPYF3cJZNLZ2gUmOi8u5XIOnYBF11HnHSTsMidMNtchJ1tnevqp87FVhA+HpjMbg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.23";
        hash = "sha512-E/Auja5pub670q5yQbv4FjmtJs4EaoAM0Ktll/w99VIdeMejDItaVKsBOY+HA0+gG4CLbftxLSE4G3qKXbyOAg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.23";
        hash = "sha512-qvKs2USwemDEytB7cv2Xp7j5PzU48bgErKuu0uhkN1OVw5+HrNLTrkpFif4WsVfB7WoqN+YvLqbkC0E/9pHLEA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.23";
        hash = "sha512-sZHcpkVLPOSwTO1TZaLeAL35WEwjeLyQxPygVHM5tP7Vdpa9iNC2cgq7PN412ZKGiX3dtC8BKuwIqWDfDWdo6g==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.23";
        hash = "sha512-KAYCw+P4Mxr/RhQIhux54Y0q0Eoy7Pl3kpi5neq+OqJ4bG7sHiZc4N5ZFY79PJTvW3nP6GMArHCoFYGyuSCcaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.23";
        hash = "sha512-EqWNSwkzF3FxwNWtli8bKVIU/lUczAwddGSMi5XJRiCr77cWdUEXAE/sDBJCiMW5TbLw/gEM3rjkmK1/95e6oA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.23";
        hash = "sha512-o5RJv5S367FkW5sNFrddQZSvFimFyM/UVQZJOPOxiZRh/v1i1RXME4jNfKkPvExqB9c7cXv6r7M1AFQTNzaQqw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.23";
        hash = "sha512-vWfFBqSWAR+2RoYgmJ9lVYAVOxR6WKODJbmNwb7e3mpAplLqwf595RYbrVUjop2D10dTl5fFX1Z3b/KHQA4brQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.23";
        hash = "sha512-WpRAtH8wc21QkHwRc28zKqgMttMliDnNZlDL3suHYHbmAAgwyL1V6RE4HIIEADCCGgowKlWvVK6oOcNvPmZkSg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.23";
        hash = "sha512-bt3sOeOsHCbFe+x9g0r5+i2ImYdYgJeARHxv3wox0b5T3vkUf/84xMNAY0o0xxHW1WHMgZ7UPqxWavou4VMf7g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.23";
        hash = "sha512-ix1yQ72nzE0f5Ug8umOkZNH2Tt+lDqO4rvm9bpIT7zIvDBNw9thIMNJkRdeTWGL3yqC4nYax7rl2D+6GAi85IQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.23";
        hash = "sha512-6fH2f9SBO9F7aYCZFN81ZEa78LSnM3/uafq+qRap8WIzQF9pvt0wOnJ8H8MRundLyXFEnC/e4eHmI3MW0lEZHQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.23";
        hash = "sha512-itybfA5aQsyKdWYeo9vJCPDV+UUPthPVSOY46Bc5JI55NNopUnKuIAJ3miOeHVTNseMB7VOAVNbrVPLVXwGqVg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.23";
        hash = "sha512-oIuhpM5aZH9jFVwYQs7/MoprK93EbsZXFYSSt3UZVsVU/1hlLLZdLI8wWpVl+QudteKdNlT2xP3cX6/dU4fkXA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.23";
        hash = "sha512-7AhcxxtaPTu/g9A/Rh6m2ERqC5pc/0cAe9M1763rHw0FdnOgS0VAUhVz7vGf6qXJSoQxFBIj50FBS3X7w8u/Vw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.23";
        hash = "sha512-siJKMLwi+Jow8sYZSwh1zF8Pk2s0CKKZLEdqNaolcFaQk07j+6o4uhMzD8UEzhzeyx5TsCBG5oDL7mcK/0jYlA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.23";
        hash = "sha512-ONNFvKjzLdTrH0kyz3B3dR98FSfD7MS3/ARA4Nz0anQ1sRz3S/2IQhDTwtJdno9zyAO2+N4CA67axF8k00OjyA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.23";
        hash = "sha512-aI6Y8PQQGWUe5v73/KXwZLxYYZ01TNp7Hxn1tau4h4SKH+kzcVDdUgWJ6Ubj+bAGQaTSWUFJoa+yLgz0oXVrgA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.23";
        hash = "sha512-KXZMqbODszGdf17My3V0C2CCOrD1Nrb9lLdkdLQiL4F402mhvtSHg0WvZ/UVRy6vChUHfOb5Lg7CthS4BgwTqw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.23";
        hash = "sha512-FacahRcDzA7r315z/EBZrnyCpSNr6sz0rUvOBRO0WhlZgfd5u73KPEqiaFmQaWuV43trv6ihi29cK/CVSDm5qg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.23";
        hash = "sha512-fAsD4f/oe5LZUdrVuW8LYM6xMr58O1o45aeMRd25KG8OBJE1XoeKW8i0aLDV89xBZEblJFxX55iBs+tO22aioQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.23";
        hash = "sha512-YT1o7j6eKh9nkf/LWBLOOHQQgHIs3dNK7LEiDSQCoUeBeIBTbXgnOcfiP8O7opuzF7R/HOtKP3KFZqHNYcqzzg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.23";
        hash = "sha512-0KBAcpY0Yn0BImmqNIlP61+Ckmp0CMCQ68RTNNjeEMDjc0VWOHVmMNJ8/utBGkdDeBUrRlN/f/dilQ7Ga/v0gw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.23";
        hash = "sha512-nEH8j0F8QyUafZVYP4f03T7QLs3alSkiBvF4LS5PP3S9HxNqiPuZKGVLheukp7ab7cwribzafanH0/iXQp57Kw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.23";
        hash = "sha512-yXydyTTAGR2Z2zB5SW8V+vlsdaQw5zYcFLvBdITF39T0Nnw8smOOsKBzB99eagZ3UTR0GnefpEEIGXsA/LJKPQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.23";
        hash = "sha512-gHvOWEysFAQtg+TV0gntiKiozSM23z+sG3Iy/eWi6sOYO4adAG+xkUOEX5nsNYkMbYbMaqQc3aOEc9MYgQTODg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.23";
        hash = "sha512-gA9KW9C7v5pZEYgfwH4GVyWRo1QxO+y620ceMuV/Yph5iQb1BCHDSC/DjOSjE9edMkPgcGCR85shpD/zG00TqA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.23";
        hash = "sha512-oyf/pqqHHyVq7pui73i7zM+yujuJYG50KTJL8H3IlcbwPSdDunx/EYT3GY7f8ObyQbi1AeqXAnQqmufyIFuWFw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.23";
        hash = "sha512-bkJtmH4+EISm99ztob6svindWPxePTCERYqhqlFPCV38ajNW7ZTDaENw5k1T45Z7Hm4OQNPGcCjQuOVVOp0gig==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.23";
        hash = "sha512-KdKnAc90T0Fsp2FoiGKJVcGa7M4NlXo/0K8/HdlIjDJmDL6BstRKQdQ6ZNHlZedS2hoRiwVN4ojyG6Pt6YBmOw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.23";
        hash = "sha512-1gtSRJA9biTHOD8ofr0WNpRCksJXx+KhFMwLKLdka5fmt07DsrEYBRT05nSoUNYfFYah0BNNJp9hzFwGH2U7BA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.23";
        hash = "sha512-N4PmalgRiIqwh3c6PYm1vLmsgKOAt8B88ILBYyOrRScS+y7D6mc7tAfRy+11C6ghBiBGJrNaXgUEANUkQ4xvrQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.23";
        hash = "sha512-kFXz6h3WyxrQDPNGqHygxGAp8F0RTxTmGHrdfBPhy/iQFf874Jn3fV+OVPuQrYZhqbtkJmMa22guPgnqeJZ8bA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.23";
        hash = "sha512-QZ5s2t+UpPDUeBVsVjRnPE+ViIGliqyRLC4IG05VM09bbVoAdizLlvQBR0y3bzAqNvT1FtYW5d2OKM4asRh+fQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.23";
        hash = "sha512-UMZ5kO3W87z6yFoC25oeltUoKmK8qZcjOrjr5OL589k14sOcEGQMsLGE65+/lNe+/Cv4pFLmWSmZCgbyGi2mKw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.23";
        hash = "sha512-dPdIBOBMWEqWlzK6KLUdCLhZnKptIMPzTENEL0xwwfkazVc/q4XNVAiVr8xpnT+zgnz3YSyR2xlNBZxJ7jmwDw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.23";
        hash = "sha512-uJWFjbnKm5pgDkZn4i0vpP8j4hSetICJrHefdR+pjZ1Gzq/JRLTIlav6sAvKYwma0TFeSfqpmIvE82C2XKYGEw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.23";
        hash = "sha512-jC3lx9tyGqjhSaQiyjk6PwGVhoDYqpSAiWpqVPQsWZERkKR+1G35yDdMssxlluqKoDTR9mfYeEPT3s50C4xJZQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.23";
        hash = "sha512-+vcoml5eEkvi84IauqYI+BJh9hZAGZjJ5KAsAG6W0e9ZRPS2df4rojbIv/8SgHawPA7WcOSz5v2t9WftcQe7RQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.23";
        hash = "sha512-dCn6RWESCLIFGXBppbCuxMUUkUOqw7MoNU0RUsGskjoiZvtiIYcTxTdNu6H5zvFFOvTxtZqdLd9SRLEXe6u+kg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.23";
        hash = "sha512-gjrMkHOyjYBewwsfCWzyIOD8SXIh96c+KiwvHrcpeBRmV9weafBNCSihzDGN9VpHfhzWe9ienPc/HntavCLlng==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.23";
        hash = "sha512-vqbK4jUkaI+ZfmF3Dxa/ncgVyLlxQVt01JAdwHQtyVgC77c3XoyLxsKPsRChbSu1iHe7AQ511a4SEjtu8VrT8A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.23";
        hash = "sha512-wgszZ8xPSQbNJRW/ikJTZ0kibyfN/DO4agul5zRBGOUdjxkOtioNu8JJbV8PuYOruwWn+HsVTo89pTxuUfaT3g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.23";
        hash = "sha512-LUwO+RyUhU6pYpzZssvK3Wv+VYoa1GSiqx6XOOfIyZyPm92BjFvar3rFpP/wzjcP+ZMdxoqxsbBBbLuZyfmICQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.23";
        hash = "sha512-oGEAu59u5za34eSmytlx5sQqpEwox8yWgkGO9xuC7UcDk4VMHtMJiTPw+M07qXAsI6pwiqCHGWQA7iuwN2e5EA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.23";
        hash = "sha512-lAdDGPyDeqw0sewoHQzcp4sqxMy24gKNGjdljAqe63TKMaxsDtiTlVtqZuAL97MgLnaRbSn5LfhcXgEFgwM3LA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.23";
        hash = "sha512-nUjn7IQyMDT6xNZym2iKunY2RT5bsNFyxfyZfvXexoFZSozojXGKpEjhEev2HMmMeolS1alJ6ZCYS3tlj+holQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.23";
        hash = "sha512-SkQMLHlWYOCvmrKTuFqWC6q/6y8amhv+RVM18j/hBx/nbGbYQ90pLTv+Vc69wSq9ugVGw0Tm7zwg9ns+Dhq8eA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.23";
        hash = "sha512-gfP1uS1t1feQ66LuwSHGXFrU/Cc/UIkFPoBZ3LySp1M4IzoCImIUJg8wlg91SpoyjOt6wQ1fAHj3nfUKdWFHwg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.23";
        hash = "sha512-xW+GrRgBSEwmwwGfUHb2pzjj3/JfA3b4uTGkjZXTJKNUe/UjW6u1YrbAFCpean8mkU5FF/IPg3w0TxHQGJGOuA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.23";
        hash = "sha512-ulFv+q99+MCffMepFZGYbhjh7IoA8nHmJ0Bcc1kAjX7NWhX9JK+dxIdoLuLsVPTJacR8EV5/8H5hd7/o6WXP9Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.23";
        hash = "sha512-ymrZ/kU4uV/h5j36fPP2pUHP7+GlTRFHLNLQsNJAJOn2TO1s/kGcidyHSaqTwHlmWUwSJJbt7d4J41xYlp3MBQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.23";
        hash = "sha512-Z8mFD3s1MnujM4GXJT8sm88txwTUSxkxjFUQGKgwP257H/BUuGIC2FWjvPZAqfs1KL7ruWhULCHd2hMTJSVkhw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.23";
        hash = "sha512-T8Goc5St6NSBj8L7f1WWZjHS4v20sWl4kc4A6dO0+lQeNNWv4gYRgZ6OXtyjWVcQRL7c16JpbJw2j8VBeEE4gA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.23";
        hash = "sha512-GSnawpqKipdOi4JOvqrKsbsu3NEu137zgk45I0+I4oh4bHZkNhCt6DDV0Vi1+sdp6krKWW7T0krSTIYIMUzZYQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.23";
        hash = "sha512-t1zUQ8Ozx3n0bn9UrW3TAXifv2DjZJ/F/LesxcdXq39Z0QBtSDvZADrGnJaUcmb+jCJlNH3w7AntXzg+s2nmPg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.23";
        hash = "sha512-vcxX841GKgEey1tptDeHyiPHACeIgATfO9AKbkBC3k5VyNyHfTrDmfv5nr/tcBVKhRR6NlMOfYqwT0JT4X+ADQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.23";
        hash = "sha512-3DXE6k3bERyP2vyibcJP6zVRKzkmk6cEqINNLjBkMN/nLG9fOwn2x+LhSQI1qvaB22p8pmM2HwCshqQ0HOR8sQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.23";
        hash = "sha512-/Rv2xB0OMMcgl0f/N78FplGIASeSCC05vgqWR9wOdnqIuv1l1s9L5RHRosO0EdCrR6SdbrCDHRfuwUn/PGF7ew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.23";
        hash = "sha512-Ze7b0VSAvxQTyC/Hb24gBBe41ZndDolclsp4N2YPesb/uHPKTf8yv6znTX83NHmFsUr3LBW0ttpwLBfCxd2y8A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.23";
        hash = "sha512-RHMNB6CgzmYsEQUtQl4Y5ukJ60m9WyhDTvm+EH31DL1d3t/Eo7bnqT/22NVEAHevWYCzfqeSeillJAVpIpqfIw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.23";
        hash = "sha512-fppHl6PIwSgOo6RJcLAyFA9zzCrrsYHsM51yyebzEJOC1gyDaABUUxO83TkqGrPiyTrVaadFRdtoRPwzyuNsyA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.23";
        hash = "sha512-mJycz2znguykPtFoyHFwkMQrvLZt7rt26s+imZiH1qhU8Ve0EJeOqBV831ihtzbQdUlEC/oi9Uf/NG8amxJqHQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.23";
        hash = "sha512-uaml9OhMUORJm7pMIqxxunYWaa4ewOQNAUWozdxAfdjXSSemmuz8LhppDWGiod6ulGpKi9T8vyyWwxRtCLvSvw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.23";
        hash = "sha512-/tXzsmZ5r1auW+5xaNjq1OoRkLCFi2rxbD2b/Ln+ygOy1FFjOJ8df36ZD9Iq/eqEanEHFu+BVWi12a7yB39rPA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.23";
        hash = "sha512-Ku0lQqoi5HvJZ/JhidwIprvKtzeNvEv5YLzoCwuf27V1Rr/T02vXTIzqPKAo38CeUCQh3TAbJ6lybmcOXiyr0g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.23";
        hash = "sha512-9tK+oGPR/DjARFjmIU3FoJ8z0inYlOuShT/HXe1P/g+RIDsl2vC4bH2ZRCOhfq6/Y5gCzCOAcHCpJsDK/eG+gg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.23";
        hash = "sha512-cJxO7OIkfvgkMk2mh6wQ7ZOzUc5QFVLD1NwozEl50S37ub5nE1jZpCiCKGepdxbfP/8Pc4vNTbbleWZNqJGvHw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.23";
        hash = "sha512-VhgTvJakZ8ee3cYOvyhiBTI+F9HGU+Un0fHt1bggBb14gVb5gT4YQ0BBRTX9lm8k0PD1M/F8g/jQkAx0nwmrBA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.23";
        hash = "sha512-VFSkRA8t8m/6Si4JLga4VUc5s8q7BgGIQ88IH4FogX5oKS7Op6FFv1MQGyTAZop8+6JZQZ0bLJRK+EjsKcgumQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.23";
        hash = "sha512-gYdHph/FuRpMunQXjuX0xam+pb5OHTcGXNTYoAaOrIQm9E25CMXRYkVyAdS8Zh15QR71ukh0uaEm5h6pHqADnQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.23";
        hash = "sha512-m6I+9zQzDZA3RSpU8KJvvNWnVTUdWbh99sOuey0kfMrk+sNfwfYVc7ZAmiDAZrGanx+tHnuECaeQa9dtDa0MPw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.23";
        hash = "sha512-mG01SXs4K3F8dNa4VGx4cypyiViuvJg25CnmJU751qjMp5WvBB0NsRAKMiYRqHFg21vbrdztfXYXagpsB7JVEQ==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.23";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.23";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.23/aspnetcore-runtime-8.0.23-linux-arm.tar.gz";
        hash = "sha512-PSAJUECag39XoA6LGVC28E44YoaqMuBYgVGE/FdeJOTgwA2Ky15pgzQi+UY2HFeTdQ8sXUmMdSTgaT4/+5R+CA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.23/aspnetcore-runtime-8.0.23-linux-arm64.tar.gz";
        hash = "sha512-wjfIhrMoqLefpuNBWQ7Gc5MlRQ0/EL6cJr+Qjk4QgrA73ziat5QxgYe7RpTyYfh+PUtGYBeyGYD/57TXDQKLuQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.23/aspnetcore-runtime-8.0.23-linux-x64.tar.gz";
        hash = "sha512-54X+KnsGpWoAcIYtT79B3w4cBLiadvTMotdd4yBkInTMxJzded1teBtQTlYx4vJbCzVmR0ufSzR6kp2LF2SD3g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.23/aspnetcore-runtime-8.0.23-linux-musl-arm.tar.gz";
        hash = "sha512-47lHe1KfL/7BJxAN6oAeLYOwM/CWyD25pvAJ7w5oowk+L6HbwliwwoiqphC6F4njgRWOFvamfxNjnv3OR7zQSQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.23/aspnetcore-runtime-8.0.23-linux-musl-arm64.tar.gz";
        hash = "sha512-CqGlD4mqOcRRHjbkrMg1MZ+rlQhruOyBJdW9tRvSCHyhhD3d+Adf5e+wndO41jQGFQhcHsqiEHvrwKguTzrZ/Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.23/aspnetcore-runtime-8.0.23-linux-musl-x64.tar.gz";
        hash = "sha512-JSkMo3Xb1X/3DhGqxrGRxUQqxGLclCRKvq/W7XpziODjQvjf9gt0GqUuM1wW8MoSz6NCY0jq6QaqX0WwtrNrXA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.23/aspnetcore-runtime-8.0.23-osx-arm64.tar.gz";
        hash = "sha512-6rgQpggD6va2SR/N/GDlC5RNAydxEQH8UTddw69E9q7JfJtbYzuIpo7KKVjBsRNJtLXdrQwTNb5Z6x+Tk5Jwiw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.23/aspnetcore-runtime-8.0.23-osx-x64.tar.gz";
        hash = "sha512-G1sEo5lOIy81nCnDvxvUHk6J+QPbXZjz1/5AMfEVoioXLbQxKeNlN0a3weBgtC8G/I7y11ZgiAVykJn1D/nSCA==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.23";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.23/dotnet-runtime-8.0.23-linux-arm.tar.gz";
        hash = "sha512-kjtSFnPUJKHxt3dT/fAK9NTYXeFIX4F/y0cXaboQtj/HfJvbijVYYc+Ck717PwCiM/+KMN6xTTmS8QOPGLrj6A==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.23/dotnet-runtime-8.0.23-linux-arm64.tar.gz";
        hash = "sha512-bV57gF+tE/pcsR+bfNPch/JXgKn9Mn1KAYOTMtMxCukW7iLVMuQKVwZSdy7j/0+wNwxnutKxDQPwe1n5PLvAfQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.23/dotnet-runtime-8.0.23-linux-x64.tar.gz";
        hash = "sha512-HG0ZgF+oCjZUKcHTkXfQ821XeoO8ml95JvqWAHQg65zru/i0hf+hMQIZV82EbT1WYgh7NYuAAkc0kRUxyY0wJw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.23/dotnet-runtime-8.0.23-linux-musl-arm.tar.gz";
        hash = "sha512-7lFVedfIys5/LytDwhswjsEre+zfcxjkLgMV9hxEG1SD99tV7hMjdpkDVPbrRyf6ZyHwAa8D3ME0KE4eEUePYQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.23/dotnet-runtime-8.0.23-linux-musl-arm64.tar.gz";
        hash = "sha512-upFLlqUOGX/cxgbIHhkm8Z8lCOaChCih8WRin5DowJvvdcF4GSGI1z7bZyqNfd7cIATzSaouT6+DeoxW1JwTRw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.23/dotnet-runtime-8.0.23-linux-musl-x64.tar.gz";
        hash = "sha512-T+xIMZDR7BNCd28t2X86zmLvT5If1A/c7rkdAM46oFbvz2NbavlzbphfPg1m3/Vwn3gaNutZMT0N3bE6s2088g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.23/dotnet-runtime-8.0.23-osx-arm64.tar.gz";
        hash = "sha512-07+vU7MYrnxMHaoOFxDE0qRPyo8defUSwRosAiYB4meqnyDofm8MMQcE3I5cHBhxNak1JB+blaWgD3icwc293A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.23/dotnet-runtime-8.0.23-osx-x64.tar.gz";
        hash = "sha512-6qzxH0gcBcNtkLbduZVCG2ou+Xg60y9JgxiUklWPsaZzPaXBjamEvtxdINMn2hrukxsst4AKquzblFOfLtFGMA==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.417";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.417/dotnet-sdk-8.0.417-linux-arm.tar.gz";
        hash = "sha512-pZdacFzgAuhCZtBCF7lPzg2hcm0QFF6qKeYpX3VRlXdJUiHFF1WJ9r6MX5MAT4jDuLi8XMyRBkYC9RK7WcUbAQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.417/dotnet-sdk-8.0.417-linux-arm64.tar.gz";
        hash = "sha512-RVgE7W5/VoQAywX4w9IOQdji/lb0HviSGBw42yz5EWRX0Lb1hU9o7acYq/zYFTvTumAm40e4OFEITfgNG+geXw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.417/dotnet-sdk-8.0.417-linux-x64.tar.gz";
        hash = "sha512-lM2LKxO2u/1b0rtpMBTvaMgPLQwxvOigxWPfTQyD3tGSa7Jmmz0RmF21kEFREEkZBJFkv8SratXFSjU/2O0A6w==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.417/dotnet-sdk-8.0.417-linux-musl-arm.tar.gz";
        hash = "sha512-un3nEQWS3aH+7Yek/5uHcc5d/V3jznPaS/FUUich/8KQIMyo6jOBGUdDYwQqU0iQwPBeZrIOjMu2FO/SMtO/og==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.417/dotnet-sdk-8.0.417-linux-musl-arm64.tar.gz";
        hash = "sha512-DwZxOAs9+ph7+VmD2IruPkGVe0CiSoXgUjeRzvipo/V+PEGXdJbET9gj+dcatQcJ0rtWuS+YRY7h7ns9mICo/Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.417/dotnet-sdk-8.0.417-linux-musl-x64.tar.gz";
        hash = "sha512-Iyzwm4JewK1wbccx5Uq76YWBWyc8zcQdVZkUJG/DP+mvuyG9PZGHDSRFtw1mnEW9bV33qb1/I39tB/YccAC9Yg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.417/dotnet-sdk-8.0.417-osx-arm64.tar.gz";
        hash = "sha512-PiO7WV5lcFjjW4MQV3EOWBI4yWSFQI7mwpj9bwp0vBpclihsHD+QLe4aRqFE4lU7+G7Zcx02+wh6Vumgxf8P5Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.417/dotnet-sdk-8.0.417-osx-x64.tar.gz";
        hash = "sha512-JZlQAyvSqXNIwhF+2hlmkYbqY/PnbHtyLEANUkwFevU9R0hjtbCxLgl3lb53d8dqdkSVVwc9d82UfMxL8HbKsg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.123";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.123/dotnet-sdk-8.0.123-linux-arm.tar.gz";
        hash = "sha512-DLe3ZPbqJ0QJExdwWldGfbpf/sSIr02PoffysSby7OXFNtpOiy1XiBiQKVbq6owdi897pwL4TrfIXq1oETTWuA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.123/dotnet-sdk-8.0.123-linux-arm64.tar.gz";
        hash = "sha512-npKANJqhJLmI08rPEQhL0JCHSgpHIQwNrpdmNWaq6t82olPv+OwfAeuq/k6MYGvGl739fmtmBvQ3QjXL8sDaeQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.123/dotnet-sdk-8.0.123-linux-x64.tar.gz";
        hash = "sha512-du3eBeF09qAVtRxgwcm/kekgkXb0RGblv6K3PlvdpMwf/sJrO2GQ2c2ns4AZjJBv/hj+JAjklT6p3XmUwTEePg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.123/dotnet-sdk-8.0.123-linux-musl-arm.tar.gz";
        hash = "sha512-dQDQhIrUHudA/hoDlWTFCD1dxoTg8B0XWf4ycmvlmyhtmoCVD56FyNJggfNEPyAYy24p4BYAEqQ6yzJ6euwRYA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.123/dotnet-sdk-8.0.123-linux-musl-arm64.tar.gz";
        hash = "sha512-ie7iwGrK8t9xN3wM/e3cAIc/gQk2eaUTh/21GGNSK/FAxAKzQm5sOo6g+7UORy0D+zyfdcAHQY+DbeCYgP/NSw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.123/dotnet-sdk-8.0.123-linux-musl-x64.tar.gz";
        hash = "sha512-i66kJ42Gn/y+4f1IeQBrciujmLW2s7y8SsRQDtCT+Y+aK4r2aATYKZK6PqLa3KBjr5NTv/khOY5Y8tm5+gs/5g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.123/dotnet-sdk-8.0.123-osx-arm64.tar.gz";
        hash = "sha512-X2LIud6U3WreMeV8MgLFnwia4Oq3Me3DWMkTnIqdSvqZYE8e9GsfOUwt1Qbf+8Ny1YR1jRfhjFQ0oPKhZ/Csvg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.123/dotnet-sdk-8.0.123-osx-x64.tar.gz";
        hash = "sha512-9sBu+Yrul0jMAYWzCvWgsMUlg0ZSPou5FCKhelpDCHZl1aDhp+7+QsAKN/4yEtnTGzznMp3H4v4gj8SAvSNrLg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
