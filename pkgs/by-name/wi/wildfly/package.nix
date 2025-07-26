{
  fetchurl,
  jre,
  lib,
  stdenvNoCC,
}:

let
  common =
    {
      version,
      url,
      hash,
    }:
    stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "wildfly";
      inherit version;

      src = fetchurl {
        inherit url hash;
      };

      buildCommand = ''
        mkdir -p "$out/opt"
        tar xf "$src" -C "$out/opt"
        mv "$out/opt/${finalAttrs.pname}-${finalAttrs.version}.Final" "$out/opt/${finalAttrs.pname}"
        find "$out/opt/${finalAttrs.pname}" -name \*.sh -print0 | xargs -0 sed -i -e '/#!\/bin\/sh/aJAVA_HOME=${jre}'
      '';

      meta = {
        description = "WildFly Application Server";
        homepage = "https://www.wildfly.org/";
        sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
        license = lib.licenses.asl20;
        maintainers = with lib.maintainers; [ ionutnechita ];
        platforms = jre.meta.platforms;
      };
    });
in
{
  wildfly-24-0-1 = common {
    version = "24.0.1";
    url = "https://download.jboss.org/wildfly/24.0.1.Final/wildfly-24.0.1.Final.tar.gz";
    hash = "sha256-eD88L5gHeYc6vHC8lRdRHWUGk2wbYRwCjnc+6R5U7o8=";
  };
  wildfly-24-0-0 = common {
    version = "24.0.0";
    url = "https://download.jboss.org/wildfly/24.0.0.Final/wildfly-24.0.0.Final.tar.gz";
    hash = "sha256-S1EIR7QQUqJQn3i/QJnvVbGnBNqzRPn0M7cG+W9ioAo=";
  };
  wildfly-23-0-2 = common {
    version = "23.0.2";
    url = "https://download.jboss.org/wildfly/23.0.2.Final/wildfly-23.0.2.Final.tar.gz";
    hash = "sha256-ZSX2NyqNvduE1+OkZtvvHgRiU8K81oLCn9D0wexgb8Q=";
  };
  wildfly-23-0-1 = common {
    version = "23.0.1";
    url = "https://download.jboss.org/wildfly/23.0.1.Final/wildfly-23.0.1.Final.tar.gz";
    hash = "sha256-ViLmK/IQ+YPRZ4/RSy0hixNEbKg6gPBLvozcbqJ2lF4=";
  };
  wildfly-23-0-0 = common {
    version = "23.0.0";
    url = "https://download.jboss.org/wildfly/23.0.0.Final/wildfly-23.0.0.Final.tar.gz";
    hash = "sha256-rJ4fyByvQay/kWJtb2XNr1K1ScZgHN9d+Jpt/oKGfSE=";
  };
  wildfly-22-0-1 = common {
    version = "22.0.1";
    url = "https://download.jboss.org/wildfly/22.0.1.Final/wildfly-22.0.1.Final.tar.gz";
    hash = "sha256-CNHkIDMdC2rWw2pN14KhEBUsq/ojQ55uzZp8TVC//QE=";
  };
  wildfly-22-0-0 = common {
    version = "22.0.0";
    url = "https://download.jboss.org/wildfly/22.0.0.Final/wildfly-22.0.0.Final.tar.gz";
    hash = "sha256-r1OBtU1CbuEsUtkEaM8OTQ7grB0XNP9jptKzdZU2APk=";
  };
  wildfly-21-0-2 = common {
    version = "21.0.2";
    url = "https://download.jboss.org/wildfly/21.0.2.Final/wildfly-21.0.2.Final.tar.gz";
    hash = "sha256-6AnBq+lD+CfaZ1qqAzinuDbayMPwJCPnNHdaSz7Jcqw=";
  };
  wildfly-21-0-1 = common {
    version = "21.0.1";
    url = "https://download.jboss.org/wildfly/21.0.1.Final/wildfly-21.0.1.Final.tar.gz";
    hash = "sha256-6LB1xEL0baseIJhcRSLYepbWzBLIyfnnwy7CQbNIFB0=";
  };
  wildfly-21-0-0 = common {
    version = "21.0.0";
    url = "https://download.jboss.org/wildfly/21.0.0.Final/wildfly-21.0.0.Final.tar.gz";
    hash = "sha256-VFTcdQwG/QUkV9MvWnujUrL7EWAv159PF4kEbTLaDZ8=";
  };
  wildfly-20-0-1 = common {
    version = "20.0.1";
    url = "https://download.jboss.org/wildfly/20.0.1.Final/wildfly-20.0.1.Final.tar.gz";
    hash = "sha256-Y87WkMBRSfRE6NBBjB12q4KUHR43Y+9MSbDEPeX5Wuc=";
  };
  wildfly-20-0-0 = common {
    version = "20.0.0";
    url = "https://download.jboss.org/wildfly/20.0.0.Final/wildfly-20.0.0.Final.tar.gz";
    hash = "sha256-QD7qoh6S1ccADC8ZYeEqxQWUlkj7wiKa9WXk78rtjew=";
  };
  wildfly-19-1-0 = common {
    version = "19.1.0";
    url = "https://download.jboss.org/wildfly/19.1.0.Final/wildfly-19.1.0.Final.tar.gz";
    hash = "sha256-Ph1/PWxIlrGAf5UkvmbMk34VZgHADPGiBWq24jzB8+c=";
  };
  wildfly-19-0-0 = common {
    version = "19.0.0";
    url = "https://download.jboss.org/wildfly/19.0.0.Final/wildfly-19.0.0.Final.tar.gz";
    hash = "sha256-AOAR+Iw2sw3PYe0cVOtvXWT2vtkDnjd0aE+hUjKOZTU=";
  };
  wildfly-18-0-1 = common {
    version = "18.0.1";
    url = "https://download.jboss.org/wildfly/18.0.1.Final/wildfly-18.0.1.Final.tar.gz";
    hash = "sha256-VEmOnBaynH8KLLq5Htq237niACJZ7gfG0SR8I9wMu2w=";
  };
  wildfly-18-0-0 = common {
    version = "18.0.0";
    url = "https://download.jboss.org/wildfly/18.0.0.Final/wildfly-18.0.0.Final.tar.gz";
    hash = "sha256-1Muy6eHjP6qd8vt9REZQJF9Lw+0A9Xl8L4tRWRWgH+M=";
  };
  wildfly-17-0-1 = common {
    version = "17.0.1";
    url = "https://download.jboss.org/wildfly/17.0.1.Final/wildfly-17.0.1.Final.tar.gz";
    hash = "sha256-KBK0O2yOYfLXZKEtWhHeeUgUYbjKxRQ06nMO5ZhdON4=";
  };
  wildfly-17-0-0 = common {
    version = "17.0.0";
    url = "https://download.jboss.org/wildfly/17.0.0.Final/wildfly-17.0.0.Final.tar.gz";
    hash = "sha256-i8WmeiRmHUTam88L3YT9KPf1H6Pcr+SylSPO9oNtmHA=";
  };
  wildfly-16-0-0 = common {
    version = "16.0.0";
    url = "https://download.jboss.org/wildfly/16.0.0.Final/wildfly-16.0.0.Final.tar.gz";
    hash = "sha256-ZeyIgcBz4f2gvikwN+t8jRmzjW5X+DBECG053ECiY4U=";
  };
  wildfly-15-0-1 = common {
    version = "15.0.1";
    url = "https://download.jboss.org/wildfly/15.0.1.Final/wildfly-15.0.1.Final.tar.gz";
    hash = "sha256-fwINZ0lehg5xmujuOLycnrbl30L7TU5Zg0MSQ8LzvwY=";
  };
  wildfly-15-0-0 = common {
    version = "15.0.0";
    url = "https://download.jboss.org/wildfly/15.0.0.Final/wildfly-15.0.0.Final.tar.gz";
    hash = "sha256-UqQcoONtxBgAIU5qj04AMidkdymYBOanGbof/jXTepI=";
  };
  wildfly-14-0-1 = common {
    version = "14.0.1";
    url = "https://download.jboss.org/wildfly/14.0.1.Final/wildfly-14.0.1.Final.tar.gz";
    hash = "sha256-4SCS7GpuBIv2ltWiPDZ0kotB3cP4EAFu8+c1Stefx0Y=";
  };
  wildfly-14-0-0 = common {
    version = "14.0.0";
    url = "https://download.jboss.org/wildfly/14.0.0.Final/wildfly-14.0.0.Final.tar.gz";
    hash = "sha256-X90fjY06HHq3awzXsNTh2NwruOOOgtTtHwj40BiqURo=";
  };
}
